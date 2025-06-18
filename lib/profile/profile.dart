import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/static_Data.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var height, width;

  String? imageUrl;
  String? name, email, phone;
  final _formKey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();

  TextEditingController phonenumbercontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    imageUrl = StaticData.model!.profilepicture;
    name = StaticData.model!.userName;
    email = StaticData.model!.userEmail;
    phone = StaticData.model!.phoneNumber;
    phonenumbercontroller.text = StaticData.model!.phoneNumber.toString();
  }

  Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    return pickedImage;
  }

  Future<String?> uploadImageToFirebase(XFile image) async {
    try {
      final Reference storageRef = FirebaseStorage.instance.ref().child(
          'profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final UploadTask uploadTask = storageRef.putFile(File(image.path));
      final TaskSnapshot taskSnapshot = await uploadTask;

      final String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> updateProfilePicture(String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(StaticData.model!.userId)
          .update({
        'profilepicture': imageUrl,
      });

      setState(() {
        StaticData.model!.profilepicture = imageUrl;
        // Force image reload by appending a timestamp
        this.imageUrl =
            '$imageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}';
      });

      print('Profile picture updated successfully!');
    } catch (e) {
      print('Failed to update profile picture: $e');
    }
  }

  Future<void> updateprofilePicture() async {
    final XFile? pickedImage = await pickImage();
    if (pickedImage != null) {
      String? imageUrl = await uploadImageToFirebase(pickedImage);
      print(imageUrl);

      if (imageUrl != null) {
        await updateProfilePicture(imageUrl);

        print('Profile picture updated successfully!');
      }
    }
  }

  Future<void> updateProfileDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(StaticData.model!.userId)
          .update({
        'userName': namecontroller.text,
        'phoneNumber': phone,
      });

      setState(() {
        StaticData.model!.userName = name;

        StaticData.model!.phoneNumber = phone;
      });

      print('Profile details updated successfully!');

      // print('Failed to update profile details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
          body: SizedBox(
        height: height,
        width: width,
        child: ListView(
          children: [
            Column(
              children: [
                InkWell(
                  onTap: () {
                    updateprofilePicture();
                  },
                  child: CircleAvatar(
                    minRadius: height * 0.05,
                    maxRadius: height * 0.07,
                    backgroundImage:
                        imageUrl != null ? NetworkImage(imageUrl!) : null,
                    child: imageUrl == null ? Icon(Icons.person) : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(labelText: 'Name'),
                    onSaved: (value) {
                      name = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: phonenumbercontroller,
                    decoration: InputDecoration(labelText: 'Phone'),
                    onSaved: (value) {
                      phone = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }

                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    updateProfileDetails();
                  },
                  child: Text('Update Profile'),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
