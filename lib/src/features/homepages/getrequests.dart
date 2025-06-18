import 'package:chat_app/src/features/homepages/controller/getrequests_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetRequestsScreen extends StatelessWidget {
  const GetRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final requestProvider = Provider.of<RequestProvider>(context);

    return Scaffold(
      body: FutureBuilder(
        future: requestProvider.fetchRequests(),
        builder: (context, snapshot) {
          return SizedBox(
            height: height,
            width: width,
            child: Column(
              children: [
                Container(
                  height: height * 0.07,
                  width: width,
                  color: const Color.fromARGB(255, 71, 26, 160),
                ),
                Container(
                  height: height * 0.07,
                  width: width,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 71, 26, 160),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: width * 0.03),
                      const Text(
                        "ChatApp",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.camera_alt_outlined,
                          size: 30, color: Colors.white),
                      SizedBox(width: width * 0.04),
                      const Icon(Icons.more_vert,
                          size: 30, color: Colors.white),
                      SizedBox(width: width * 0.03),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: requestProvider.requests.length,
                    itemBuilder: (context, index) {
                      final request = requestProvider.requests[index];
                      return SizedBox(
                        height: height * 0.12,
                        width: width,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: AssetImage(
                              "assets/images/pexels-moh-adbelghaffar-771742.jpg",
                            ),
                          ),
                          title: Text(
                            request.senderName ?? '',
                            style: TextStyle(
                              fontSize: height * 0.015,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text("Request to chat"),
                          trailing: SizedBox(
                            height: height * 0.1,
                            width: width * 0.47,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 187, 132, 232),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 151, 71, 255),
                                      ),
                                    ),
                                  ),
                                  onPressed: () =>
                                      requestProvider.acceptRequest(request),
                                  child: const Text(
                                    "Accept",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 187, 132, 232),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 151, 71, 255),
                                      ),
                                    ),
                                  ),
                                  onPressed: () =>
                                      requestProvider.rejectRequest(request),
                                  child: const Text(
                                    "Reject",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
