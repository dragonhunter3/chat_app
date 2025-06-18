import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:chat_app/chatScreen/dialogbox.dart';
import 'package:chat_app/models/groupmodel.dart';
import 'package:chat_app/models/static_Data.dart';

class GroupsFirends extends StatefulWidget {
  const GroupsFirends({super.key});

  @override
  State<GroupsFirends> createState() => _GroupsFirendsState();
}

class _GroupsFirendsState extends State<GroupsFirends> {
  var height, width;
  List<GroupModel> grouplist = [];
  getGroups() async {
    grouplist.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Group")
        .where("userid", isEqualTo: [StaticData.model!.userId]).get();
    for (var data in snapshot.docs) {
      GroupModel model =
          GroupModel.fromMap(data.data() as Map<String, dynamic>);
      setState(() {
        grouplist.add(model);
      });
    }
  }

  @override
  void initState() {
    getGroups();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CustomDialogbox11(),
          );
        },
        child: Icon(Icons.add),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: ListView.builder(
          itemCount: grouplist.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  height: height * 0.1,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  child: Text(grouplist[index].groupName!),
                ),
                SizedBox(
                  height: height * 0.01,
                )
              ],
            );
          },
        ),
      ),
    ));
  }
}
