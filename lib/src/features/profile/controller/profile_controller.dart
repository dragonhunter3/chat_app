import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_app/src/features/models/static_Data.dart';

class ProfileProvider with ChangeNotifier {
  String? imageUrl;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  void initializeFields() {
    imageUrl = StaticData.model?.profilepicture;
    nameController.text = StaticData.model?.userName ?? '';
    phoneController.text = StaticData.model?.phoneNumber ?? '';
  }

  Future<void> updateProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final String? downloadURL = await _uploadImageToFirebase(pickedImage);
      if (downloadURL != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(StaticData.model!.userId)
            .update({'profilepicture': downloadURL});

        imageUrl =
            '$downloadURL?timestamp=${DateTime.now().millisecondsSinceEpoch}';
        StaticData.model!.profilepicture = downloadURL;
        notifyListeners();
      }
    }
  }

  Future<String?> _uploadImageToFirebase(XFile image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(File(image.path));
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  Future<void> updateProfileDetails(String name, String phone) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(StaticData.model!.userId)
          .update({'userName': name, 'phoneNumber': phone});

      StaticData.model!.userName = name;
      StaticData.model!.phoneNumber = phone;
      notifyListeners();
    } catch (e) {
      print('Profile update failed: $e');
    }
  }

  void disposeControllers() {
    nameController.dispose();
    phoneController.dispose();
  }
}
