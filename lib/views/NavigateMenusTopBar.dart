import 'package:flutter/material.dart';
import 'package:timestory_back4app/views/Expenses.dart';
import 'package:timestory_back4app/views/Home.dart';
import 'package:timestory_back4app/views/Projects.dart';
import 'package:timestory_back4app/views/ReadTimeSheet.dart';

import 'QuickAdd.dart';

class NavigateMenuTopBar extends StatefulWidget {
  final index;
  const NavigateMenuTopBar({Key? key, this.index}) : super(key: key);

  @override
  State<NavigateMenuTopBar> createState() => _NavigateMenuTopBarState();
}

class _NavigateMenuTopBarState extends State<NavigateMenuTopBar> {

  int _currentPageIndex = 0;
  final List _widgetClasses = [
    Home(),
    ReadTimeSheet(),
    Expenses(),
    Projects(),
    QuickAdd(),
  ];
  @override
  void initState() {
    _currentPageIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    void onTapped(int value) {
      setState(() {
        _currentPageIndex = value;
        debugPrint("NavigateMenusTopBar:Index: $_currentPageIndex");
      });
    }

    return MaterialApp(
      home:Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(_width, 150),
          child: NavigationBar(
            backgroundColor: Colors.yellow.shade50,
            onDestinationSelected: onTapped,
            selectedIndex: _currentPageIndex,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home, color: Colors.brown, size: 50), label: 'Home' ),
              NavigationDestination(icon: Icon(Icons.update, color: Colors.brown, size: 50), label: 'TimeSheet'),
              NavigationDestination(icon: Icon(Icons.money_outlined, color: Colors.brown, size: 50), label: 'Expenses'),
              NavigationDestination(icon: Icon(Icons.home_work, color: Colors.brown, size: 50), label: 'Projects'),
              NavigationDestination(icon: Icon(Icons.add_circle, color: Colors.brown, size: 50), label: 'Quick Add ')
            ],
      ),
    ),
        body: Center(child: _widgetClasses.elementAt(_currentPageIndex),),));
  }
}