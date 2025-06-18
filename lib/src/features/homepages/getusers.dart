import 'package:chat_app/src/features/homepages/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetUsersScreen extends StatefulWidget {
  const GetUsersScreen({super.key});

  @override
  State<GetUsersScreen> createState() => _GetUsersScreenState();
}

class _GetUsersScreenState extends State<GetUsersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(width, height),
          Expanded(
            child: userProvider.userList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: userProvider.userList.length,
                    itemBuilder: (context, index) {
                      final user = userProvider.userList[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/images/pexels-moh-adbelghaffar-771742.jpg",
                          ),
                        ),
                        title: Text(
                          user.userName ?? 'Unknown',
                          style: TextStyle(
                            fontSize: height * 0.017,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text("Last message"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildButton(
                              label: "Send",
                              onPressed: () {
                                userProvider.sendRequest(user);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Request Sent"),
                                  ),
                                );
                              },
                              width: width * 0.17,
                              height: height * 0.05,
                            ),
                            const SizedBox(width: 8),
                            _buildButton(
                              label: "Remove",
                              onPressed: () {},
                              width: width * 0.20,
                              height: height * 0.05,
                            ),
                          ],
                        ),
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
          color: const Color.fromARGB(255, 71, 26, 160),
        ),
        Container(
          height: height * 0.07,
          width: width,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 71, 26, 160),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
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
                  size: 30, color: Colors.white),
              const SizedBox(width: 16),
              const Icon(Icons.more_vert, size: 30, color: Colors.white),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 187, 132, 232),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color.fromARGB(255, 151, 71, 255)),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
