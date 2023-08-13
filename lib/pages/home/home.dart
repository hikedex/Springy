import 'package:flutter/material.dart';
import 'package:hikedex/pages/home/components/profile.dart';
import 'package:provider/provider.dart';
import 'package:hikedex/pages/home/components/map.dart';
import 'package:hikedex/pages/home/components/selectArea.dart';
import 'package:hikedex/providers/apiProvider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPageIndex = 0;
  void _onDestinationSelected(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  List<Widget> _pages = [
    MapPage(),
    ProfilePage(),
  ];

  List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: const Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: const Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (Provider.of<ApiProvider>(context).summits.isEmpty) {
      return SelectArea();
    } else {
      return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Home'),
        // ),
        // body is a future builder that will build the map when the location is found
        bottomNavigationBar: NavigationBar(
          backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
          onDestinationSelected: _onDestinationSelected,
          selectedIndex: _currentPageIndex,
          destinations: _destinations,
          labelBehavior: MediaQuery.of(context).size.width > 450
              ? null
              : NavigationDestinationLabelBehavior.alwaysHide,
          height: 70,
        ),
        body: _pages[_currentPageIndex],
      );
    }
  }
}
