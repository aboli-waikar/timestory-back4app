import 'package:flutter/material.dart';
import 'package:timestory_back4app/views/Expenses.dart';
import 'package:timestory_back4app/views/Home.dart';
import 'package:timestory_back4app/views/Profile.dart';
import 'package:timestory_back4app/views/ReadTimeSheet.dart';

class NavigateMenuTopBar extends StatefulWidget {
  const NavigateMenuTopBar({Key? key}) : super(key: key);

  @override
  State<NavigateMenuTopBar> createState() => _NavigateMenuTopBarState();
}

class _NavigateMenuTopBarState extends State<NavigateMenuTopBar> {

  int _currentPageIndex = 0;
  final List _widgetClasses = [
    Home(),
    ReadTimeSheet(),
    Expenses(),
    Profile(),
    Home(),
  ];

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    void onTapped(int value) {
      setState(() {
        _currentPageIndex = value;
        debugPrint("Index: $_currentPageIndex");
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
              NavigationDestination(icon: Icon(Icons.person, color: Colors.brown, size: 50), label: 'Profile'),
              NavigationDestination(icon: Icon(Icons.add_circle, color: Colors.brown, size: 50), label: 'Quick Add ')
            ],
      ),
    ),
        body: Center(child: _widgetClasses.elementAt(_currentPageIndex),),));
  }
}
