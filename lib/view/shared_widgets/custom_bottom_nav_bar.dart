import 'package:flutter/material.dart';
import 'package:namaz_bajamat/config/routes/routes_name.dart';

class CustomBottomNavBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomBottomNavBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          border: Border.all(color: Colors.transparent)
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.primaryColor,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.mosque), label: "All Mosques"),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: "Qibla Finder"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index){
          switch (index) {
            case 3:
              scaffoldKey.currentState?.openDrawer();
            case 1:
              Navigator.pushNamed(context, RoutesName.allMosques);
            case 2:
              Navigator.pushNamed(context, RoutesName.qiblaFinder);
          }
        },
      ),
    );
  }
}
