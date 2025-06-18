import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/requestmodel.dart';
import 'package:chat_app/models/static_Data.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:uuid/uuid.dart';

class GetUsersScreen extends StatefulWidget {
  const GetUsersScreen({super.key});

  @override
  State<GetUsersScreen> createState() => _GetUsersScreenState();
}

class _GetUsersScreenState extends State<GetUsersScreen> {
  var height, width;
  List<UserModel> userlist = [];
  getUsers() async {
    userlist.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isNotEqualTo: StaticData.model!.userId)
        .get();
    for (var data in snapshot.docs) {
      UserModel model = UserModel.fromMap(data.data() as Map<String, dynamic>);
      setState(() {
        userlist.add(model);
      });
    }
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                        width: width * 0.52,
                      ),
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.more_vert,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userlist.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: height * 0.12,
                        width: width,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                                "assets/images/pexels-moh-adbelghaffar-771742.jpg"),
                          ),
                          title: Text(
                            userlist[index].userName!,
                            style: TextStyle(
                                fontSize: height * 0.015,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Last message"),
                          trailing: SizedBox(
                              height: height * 0.08,
                              width: width * 0.4,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                      height: height * 0.05,
                                      width: width * 0.17,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 187, 132, 232),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 151, 71, 255)))),
                                          onPressed: () {
                                            var uid = Uuid();
                                            String sendreid = uid.v4();
                                            RequestModel model = RequestModel(
                                              reciverName:
                                                  userlist[index].userName,
                                              reciverId: userlist[index].userId,
                                              senderName:
                                                  StaticData.model!.userName,
                                              senderId:
                                                  StaticData.model!.userId,
                                              requestId: sendreid,
                                            );
                                            FirebaseFirestore.instance
                                                .collection("Requests")
                                                .doc(sendreid)
                                                .set(model.toMap());
                                          },
                                          child: Text(
                                            "Send",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                                  SizedBox(
                                      height: height * 0.05,
                                      width: width * 0.2,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 187, 132, 232),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 151, 71, 255)))),
                                          onPressed: () {},
                                          child: Text(
                                            "Remove",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                                ],
                              )),
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
