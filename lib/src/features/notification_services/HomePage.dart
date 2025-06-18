import 'package:flutter/material.dart';
import 'package:chat_app/src/features/notification_services/notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationsScreen notificationservices = NotificationsScreen();
  var height, width;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationservices.requestNotificationPermission();
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height * 0.5,
              width: width * 0.8,
              color: Colors.amber,
            )
          ],
        ),
      ),
    );
  }
}
