import 'package:chat_app/src/features/homepages/controller/friends_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/src/features/models/static_Data.dart';
import 'package:chat_app/src/features/profile/profile.dart';
import 'package:chat_app/src/features/chatScreen/chatscreen.dart';
import 'package:chat_app/src/features/homepages/getusers.dart';

enum SampleItem { itemOne, itemTwo }

class GetFirendScreen extends StatefulWidget {
  const GetFirendScreen({super.key});

  @override
  State<GetFirendScreen> createState() => _GetFirendScreenState();
}

class _GetFirendScreenState extends State<GetFirendScreen> {
  SampleItem? selectedItem;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<FriendProvider>(context, listen: false).fetchFriends();
    });
  }

  String chatRoomId(String user1, String user2) {
    return (user1.compareTo(user2) > 0) ? "$user1$user2" : "$user2$user1";
  }

  @override
  Widget build(BuildContext context) {
    final friendProvider = Provider.of<FriendProvider>(context);
    final friends = friendProvider.friendList;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 223, 220, 220),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GetUsersScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Column(
        children: [
          _buildAppBar(width, height),
          Expanded(
            child: friends.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      return ListTile(
                        onTap: () {
                          final chatID = chatRoomId(
                              StaticData.model!.userId!, friend.friendId!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                chatroomId: chatID,
                                profileModel: friend,
                              ),
                            ),
                          );
                        },
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/images/pexels-moh-adbelghaffar-771742.jpg",
                          ),
                        ),
                        title: Text(
                          friend.friendName ?? '',
                          style: TextStyle(
                              fontSize: height * 0.017,
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text("Last message"),
                        trailing: const Text("Today"),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(double width, double height) {
    return Column(
      children: [
        Container(
            height: height * 0.07,
            width: width,
            color: const Color(0xFF471AA0)),
        Container(
          height: height * 0.07,
          width: width,
          decoration: const BoxDecoration(
            color: Color(0xFF471AA0),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Text(
                "ChatApp",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              const Spacer(),
              const Icon(Icons.camera_alt_outlined,
                  color: Colors.white, size: 28),
              const SizedBox(width: 12),
              PopupMenuButton<SampleItem>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                initialValue: selectedItem,
                onSelected: (item) {
                  if (item == SampleItem.itemTwo) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileScreen()));
                  } else if (item == SampleItem.itemOne) {
                    // handle logout here
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: SampleItem.itemOne,
                    child: Row(
                      children: [
                        Icon(Icons.logout_outlined),
                        SizedBox(width: 8),
                        Text("Logout")
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: SampleItem.itemTwo,
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 8),
                        Text("Profile")
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ],
    );
  }
}
