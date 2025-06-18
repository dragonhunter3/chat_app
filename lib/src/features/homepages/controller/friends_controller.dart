import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/src/features/models/firendmodel.dart';
import 'package:chat_app/src/features/models/static_Data.dart';

class FriendProvider with ChangeNotifier {
  List<Firendmodel> _friendList = [];
  List<Firendmodel> get friendList => _friendList;

  Future<void> fetchFriends() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Firends')
          .where('userId', isEqualTo: StaticData.model!.userId)
          .get();

      _friendList = snapshot.docs
          .map((doc) => Firendmodel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (e) {
      print("Error fetching friends: $e");
    }
  }
}
