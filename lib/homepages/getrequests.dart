import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/firendmodel.dart';
import 'package:chat_app/models/requestmodel.dart';
import 'package:chat_app/models/static_Data.dart';
import 'package:uuid/uuid.dart';

class GetRequestsScreen extends StatefulWidget {
  const GetRequestsScreen({super.key});

  @override
  State<GetRequestsScreen> createState() => _GetRequestsScreenState();
}

class _GetRequestsScreenState extends State<GetRequestsScreen> {
  var height, width;
  List<RequestModel> requestslist = [];
  getRequests() async {
    requestslist.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Requests")
        .where("reciverId", isEqualTo: StaticData.model!.userId)
        .get();
    for (var data in snapshot.docs) {
      RequestModel reqmodel =
          RequestModel.fromMap(data.data() as Map<String, dynamic>);
      setState(() {
        requestslist.add(reqmodel);
      });
    }
  }

  @override
  void initState() {
    getRequests();
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
                    itemCount: requestslist.length,
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
                            requestslist[index].senderName!,
                            style: TextStyle(
                                fontSize: height * 0.015,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Last message"),
                          trailing: SizedBox(
                            height: height * 0.1,
                            width: width * 0.47,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: height * 0.05,
                                  width: width * 0.23,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
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
                                        String firstid = uid.v4();
                                        Firendmodel model = Firendmodel(
                                            friendId:
                                                requestslist[index].reciverId,
                                            friendName:
                                                requestslist[index].reciverName,
                                            userId:
                                                requestslist[index].senderId,
                                            id: firstid);
                                        String second = uid.v4();
                                        Firendmodel modelsecond = Firendmodel(
                                            friendId:
                                                requestslist[index].senderId,
                                            friendName:
                                                requestslist[index].senderName,
                                            userId:
                                                requestslist[index].reciverId,
                                            id: second);
                                        FirebaseFirestore.instance
                                            .collection('Firends')
                                            .doc(firstid)
                                            .set(model.toMap());
                                        FirebaseFirestore.instance
                                            .collection('Firends')
                                            .doc(second)
                                            .set(modelsecond.toMap());
                                        Future.delayed(Duration(seconds: 2),
                                            () {
                                          FirebaseFirestore.instance
                                              .collection("Requests")
                                              .doc(
                                                  requestslist[index].requestId)
                                              .delete();
                                        });
                                      },
                                      child: Center(
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  height: height * 0.05,
                                  width: width * 0.23,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              255, 187, 132, 232),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 151, 71, 255)))),
                                      onPressed: () {
                                        Future.delayed(Duration(seconds: 2),
                                            () {
                                          FirebaseFirestore.instance
                                              .collection("Requests")
                                              .doc(
                                                  requestslist[index].requestId)
                                              .delete();
                                        });
                                      },
                                      child: Text(
                                        "Reject",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                )
                              ],
                            ),
                          ),
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
