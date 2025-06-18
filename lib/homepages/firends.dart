import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/chatScreen/chatscreen.dart';
import 'package:chat_app/homepages/getusers.dart';
import 'package:chat_app/models/firendmodel.dart';
import 'package:chat_app/models/static_Data.dart';
import 'package:chat_app/profile/profile.dart';

enum SampleItem { itemOne, itemTwo }

class GetFirendScreen extends StatefulWidget {
  const GetFirendScreen({super.key});

  @override
  State<GetFirendScreen> createState() => _GetFirendScreenState();
}

class _GetFirendScreenState extends State<GetFirendScreen> {
  var height, width;
  List<Firendmodel> firendlist = [];
  getFirend() async {
    firendlist.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Firends')
        .where('userId', isEqualTo: StaticData.model!.userId)
        .get();
    for (var data in snapshot.docs) {
      Firendmodel model =
          Firendmodel.fromMap(data.data() as Map<String, dynamic>);
      setState(() {
        firendlist.add(model);
      });
    }
  }

  SampleItem? selectedItem;
  @override
  void initState() {
    getFirend();
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: IconButton(
          style: IconButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 223, 220, 220)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GetUsersScreen(),
                ));
          },
          icon: Icon(Icons.add)),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Expanded(
              child: Column(children: [
                Container(
                  height: height * 0.07,
                  width: width,
                  color: Color.fromARGB(255, 71, 26, 160),
                ),
                Container(
                  height: height * 0.07,
                  width: width,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 71, 26, 160),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Text(
                        "ChatApp",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: width * 0.46,
                      ),
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      PopupMenuButton<SampleItem>(
                        iconSize: 30,
                        icon: Icon(Icons.more_vert, color: Colors.white),
                        initialValue: selectedItem,
                        onSelected: (SampleItem item) {
                          setState(() {
                            selectedItem = item;
                          });
                          Navigator.pop(context);
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<SampleItem>>[
                          PopupMenuItem<SampleItem>(
                            value: SampleItem.itemOne,
                            child: Row(
                              children: [
                                Icon(Icons.logout_outlined),
                                Text("Logout")
                              ],
                            ),
                          ),
                          PopupMenuItem<SampleItem>(
                            value: SampleItem.itemTwo,
                            child: Row(
                              children: [
                                Icon(Icons.person),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileScreen(),
                                          ));
                                    },
                                    child: Text("Profile"))
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: firendlist.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: height * 0.12,
                        width: width,
                        child: ListTile(
                          leading: InkWell(
                            onTap: () {
                              String chatID = chatRoomId(
                                  StaticData.model!.userId!,
                                  firendlist[index].friendId!);
                              print(chatID);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      chatroomId: chatID,
                                      profileModel: firendlist[index],
                                    ),
                                  ));
                            },
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/pexels-moh-adbelghaffar-771742.jpg"),
                            ),
                          ),
                          title: Text(
                            firendlist[index].friendName!,
                            style: TextStyle(
                                fontSize: height * 0.015,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Last message"),
                          trailing: Text("Today"),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
