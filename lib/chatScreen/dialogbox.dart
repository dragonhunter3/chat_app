import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/groupmodel.dart';
import 'package:chat_app/models/static_Data.dart';
import 'package:uuid/uuid.dart';

class CustomDialogbox11 extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  var height, width;

  CustomDialogbox11({super.key});
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Dialog(
      child: SizedBox(
        height: height * 0.3,
        width: width * 0.7,
        child: Column(
          children: [
            Text("Create Group"),
            SizedBox(
              height: height * 0.07,
              width: width * 0.5,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue))),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            SizedBox(
              height: height * 0.04,
              width: width * 0.2,
              child: ElevatedButton(
                  onPressed: () {
                    var uid = Uuid();
                    String gid = uid.v4();
                    GroupModel model = GroupModel(
                        groupName: controller.text,
                        groupid: gid,
                        userid: [StaticData.model!.userId.toString()]);
                    FirebaseFirestore.instance
                        .collection("Group")
                        .doc(gid)
                        .set(model.toMap());
                    Navigator.pop(context);
                  },
                  child: Text("Ok")),
            ),
          ],
        ),
      ),
    );
  }
}
