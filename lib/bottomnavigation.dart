import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

import 'package:flutter/material.dart';
import 'package:chat_app/src/features/homepages/firends.dart';
import 'package:chat_app/src/features/homepages/getrequests.dart';
import 'package:chat_app/src/features/homepages/getusers.dart';
import 'package:chat_app/src/features/homepages/userscall.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final screens = [
    GetFirendScreen(),
    GetUsersScreen(),
    GetRequestsScreen(),
    UserCallScreen(),
    // History(),
  ];

  PageController controller = PageController();
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final items = <CurvedNavigationBarItem>[
    CurvedNavigationBarItem(
        child: Icon(Icons.chat_outlined),
        label: "Chat",
        labelStyle: TextStyle(fontFamily: 'font1', color: Colors.white)),
    CurvedNavigationBarItem(
      child: Icon(Icons.auto_mode_outlined),
      label: "Status",
      labelStyle: TextStyle(fontFamily: 'font1', color: Colors.white),
    ),
    CurvedNavigationBarItem(
        child: Icon(Icons.person),
        label: "Requests",
        labelStyle: TextStyle(fontFamily: 'font1', color: Colors.white)),
    CurvedNavigationBarItem(
        child: Icon(Icons.phone_outlined),
        label: "Calls",
        labelStyle: TextStyle(fontFamily: 'font1', color: Colors.white)),
  ];
  int index = 0;
  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: Builder(builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: Colors.white),
            bottomNavigationBarTheme:
                BottomNavigationBarThemeData(backgroundColor: Colors.purple),
          ),
          child: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: Color.fromARGB(255, 151, 71, 255),
            key: _bottomNavigationKey,
            color: Color.fromARGB(255, 151, 71, 255),
            index: index,
            height: 60,
            items: items,
            onTap: (value) => setState(() {
              index = value;
            }),
          ),
        );
      }),
    );
  }
}
