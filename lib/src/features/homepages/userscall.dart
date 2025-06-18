import 'package:flutter/material.dart';

class UserCallScreen extends StatefulWidget {
  const UserCallScreen({super.key});

  @override
  State<UserCallScreen> createState() => _UserCallScreenState();
}

class _UserCallScreenState extends State<UserCallScreen> {
  var height, width;
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
                    itemCount: 10,
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
                            "Muhammad Shahid",
                            style: TextStyle(
                                fontSize: height * 0.015,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Last message"),
                          trailing: Icon(Icons.call),
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
