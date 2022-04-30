import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timestory_back4app/model/UserDataModel.dart';
import 'package:timestory_back4app/views/Expenses.dart';
import 'package:timestory_back4app/views/Home.dart';
import 'package:timestory_back4app/views/Projects.dart';
import 'package:timestory_back4app/views/QuickAdd.dart';

import 'package:side_navigation/side_navigation.dart';

class SideNavigationPage extends StatefulWidget {
  int index;
  final UserDataModel timeStoryUser;

  SideNavigationPage({Key? key, this.index: 0, required this.timeStoryUser}) : super(key: key);

  @override
  State<SideNavigationPage> createState() => _SideNavigationPageState();
}

class _SideNavigationPageState extends State<SideNavigationPage> {


  final List _widgetClasses = [
    Home(),
    Expenses(),
    Projects(),
    QuickAdd(),
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.timeStoryUser.photoUrl);
    return Scaffold(
      body: Row(
        children: [
          SideNavigationBar(
            header: SideNavigationBarHeader(
                image: (widget.timeStoryUser.photoUrl != null)
                    ? Image(image: NetworkImage(widget.timeStoryUser.photoUrl), fit: BoxFit.cover)
                    : CircleAvatar(child: Icon(Icons.account_balance)),
                title: Text(widget.timeStoryUser.username),
                subtitle: Text(widget.timeStoryUser.email)),
            selectedIndex: widget.index,
            onTap: (index) {
              setState(() {
                widget.index = index;
                debugPrint(widget.index.toString());
              });
            },
            items: const [
              SideNavigationBarItem(
                icon: Icons.home,
                label: 'Home',
              ),
              SideNavigationBarItem(
                icon: Icons.money_outlined,
                label: 'Expenses',
              ),
              SideNavigationBarItem(
                icon: Icons.home_work,
                label: 'Projects',
              ),
              SideNavigationBarItem(
                icon: Icons.add_circle,
                label: 'Quick Add',
              ),
            ],
          ),
          Expanded(
            child: _widgetClasses.elementAt(widget.index),
          )
        ],
      ),
    );
  }
}
