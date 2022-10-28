import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubaline_ta/providers/search_provider.dart';
import 'package:tubaline_ta/screens/home/home.dart';
import 'package:tubaline_ta/screens/profiles/profile.dart';
import 'package:tubaline_ta/widgets/loading.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Widget> _listIndex = <Widget>[
  const Home(),
  const Profile(),
];

final _mainNavigatorKey = GlobalKey<NavigatorState>();

class _MyHomePageState extends State<MyHomePage> {
  int _currentTab = 0;

  void _selectedTab(int index) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(top: true, child: _listIndex.elementAt(_currentTab)),
      bottomNavigationBar: BottomNavigationBar(
        key: _mainNavigatorKey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
        currentIndex: _currentTab,
        onTap: _selectedTab,
      ),
    );
  }
}
