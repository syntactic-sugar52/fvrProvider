import 'package:flutter/material.dart';
import 'package:fprovider_app/constants/colors.dart';
import 'package:fprovider_app/screens/tabs/earnings_tab.dart';
import 'package:fprovider_app/screens/tabs/profile_tab.dart';
import 'package:fprovider_app/screens/tabs/rating_tab.dart';
import 'tabs/home_tab.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = 'mainscreen';
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int selectedIndex = 0;
  void onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [HomeTab(), EarningsTab(), RatingTab(), ProfileTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: "Profit"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Rating"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account")
        ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: kPrimaryGreen,
        type: BottomNavigationBarType.fixed,
        backgroundColor: kPrimaryWhite,
        showSelectedLabels: true,
        onTap: onItemClicked,
        selectedLabelStyle: TextStyle(fontSize: 14.0),
        currentIndex: selectedIndex,
        showUnselectedLabels: true,
      ),
    );
  }
}
