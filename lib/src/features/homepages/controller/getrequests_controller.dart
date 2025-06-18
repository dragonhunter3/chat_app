import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/src/features/models/requestmodel.dart';
import 'package:chat_app/src/features/models/firendmodel.dart';
import 'package:chat_app/src/features/models/static_Data.dart';
import 'package:uuid/uuid.dart';

class RequestProvider with ChangeNotifier {
  List<RequestModel> _requests = [];
  List<RequestModel> get requests => _requests;

  Future<void> fetchRequests() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Requests")
        .where("reciverId", isEqualTo: StaticData.model?.userId)
        .get();

    _requests =
        snapshot.docs.map((doc) => RequestModel.fromMap(doc.data())).toList();
    notifyListeners();
  }

  Future<void> acceptRequest(RequestModel request) async {
    final uid = const Uuid();
    final firstId = uid.v4();
    final secondId = uid.v4();

    Firendmodel firstFriend = Firendmodel(
      friendId: request.reciverId,
      friendName: request.reciverName,
      userId: request.senderId,
      id: firstId,
    );

    Firendmodel secondFriend = Firendmodel(
      friendId: request.senderId,
      friendName: request.senderName,
      userId: request.reciverId,
      id: secondId,
    );

    await FirebaseFirestore.instance
        .collection('Firends')
        .doc(firstId)
        .set(firstFriend.toMap());

    await FirebaseFirestore.instance
        .collection('Firends')
        .doc(secondId)
        .set(secondFriend.toMap());

    await FirebaseFirestore.instance
        .collection('Requests')
        .doc(request.requestId)
        .delete();

    _requests.removeWhere((r) => r.requestId == request.requestId);
    notifyListeners();
  }

  Future<void> rejectRequest(RequestModel request) async {
    await FirebaseFirestore.instance
        .collection('Requests')
        .doc(request.requestId)
        .delete();

    _requests.removeWhere((r) => r.requestId == request.requestId);
    notifyListeners();
  }
}
