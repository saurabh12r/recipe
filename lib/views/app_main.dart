import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe/utils/const.dart';
import 'package:recipe/views/FavoriteScreen.dart';
import 'package:recipe/views/mt_app_home_screen.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AppmainScreenState();
}

class _AppmainScreenState extends State<AppMainScreen> {
  int selectedIndex = 0;
  late final List<Widget> page;

  @override
  void initState() {
    page = [
      MtAppHomeScreen(),
      FavoriteScreen(),
      navBarPage(Iconsax.calendar),
      navBarPage(Iconsax.setting),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 28,
        currentIndex: selectedIndex,
        selectedLabelStyle:
            TextStyle(color: kprimaryColor, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        selectedItemColor: kprimaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(selectedIndex == 0 ? Iconsax.home5 : Iconsax.home1),
              label: "home"),
          BottomNavigationBarItem(
              icon: Icon(selectedIndex == 1 ? Iconsax.heart5 : Iconsax.heart),
              label: "fav"),
          BottomNavigationBarItem(
              icon: Icon(
                  selectedIndex == 2 ? Iconsax.calendar : Iconsax.calendar),
              label: "meal"),
          BottomNavigationBarItem(
              icon: Icon(
                  selectedIndex == 3 ? Iconsax.setting_21 : Iconsax.setting_21),
              label: "setting"),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      body: page[selectedIndex],
    );
  }

  Widget navBarPage(iconName) {
    return Center(
      child: Icon(
        iconName,
        size: 100,
        color: kprimaryColor,
      ),
    );
  }
}
