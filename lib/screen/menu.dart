import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/screen/commande.dart';
import 'package:myapp/screen/favoris.dart';
import 'package:myapp/screen/homescreen.dart';
import 'package:myapp/screen/panier.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late PageController _pageController;
  int selectedIndex = 0;
  bool _colorful = false;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(selectedIndex,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: _listOfWidget,
        ),
        bottomNavigationBar: SlidingClippedNavBar.colorful(
          backgroundColor: Colors.white,
          onButtonPressed: onButtonPressed,
          iconSize: 30,
          // activeColor: const Color(0xFF01579B),
          selectedIndex: selectedIndex,
          barItems: <BarItem>[
            BarItem(
              icon: Iconsax.home,
              title: 'Produit',
              activeColor: Colors.blue,
              inactiveColor: Colors.black,
            ),
            BarItem(
              icon: Icons.bolt_rounded,
              title: 'Souhait',
              activeColor: Colors.blue,
              inactiveColor: Colors.black,
            ),
            BarItem(
              icon: Iconsax.bag,
              title: 'Panier',
              activeColor: Colors.blue,
              inactiveColor: Colors.black,
            ),
            BarItem(
              icon: Icons.delivery_dining,
              title: 'Commande',
              activeColor: Colors.blue,
              inactiveColor: Colors.black,
            ),
          ],
        ));
  }
}

// icon size:24 for fontAwesomeIcons
// icons size: 30 for MaterialIcons

List<Widget> _listOfWidget = <Widget>[
  Homescreen(),
  Favoris(),
  Panier(),
  Commande(),
];
