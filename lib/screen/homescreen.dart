import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:myapp/controller/allcontroler.dart';
import 'package:myapp/controller/databasecontroller.dart';
import 'package:myapp/screen/detailscreen.dart';
import 'package:myapp/screen/login.dart';
import 'package:myapp/screen/notification.dart';
import 'package:myapp/screen/profil.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final PageController _pageController = PageController();
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1655772505.
  final allcontroller = Get.put(Allcontroller());
  int _currentPage = 0;
  Timer? _timer;
  final List<Product> products = [
    Product(
        name: 'Produit 1',
        color: const Color(0XFFFFFAAAA),
        price: 10.0,
        image: "assets/1.png"),
    Product(
        name: 'Produit 2',
        color: const Color(0XFFFFF4C4C),
        price: 20.0,
        image: "assets/2.png"),
    Product(
        name: 'Produit 3',
        color: const Color(0XFFF987D9A),
        price: 30.0,
        image: "assets/3.png"),
    Product(
        name: 'Produit 4',
        color: const Color(0XFFF3FEB8),
        price: 40.0,
        image: "assets/4.png"),
    Product(
        name: 'Produit 5',
        color: const Color(0XFFA0937D),
        price: 50.0,
        image: "assets/5.png"),
  ];
  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WOOP',
          style: TextStyle(fontSize: 30),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Notifications()),
              );
            },
            child: const CircleAvatar(
              backgroundColor: Color(0XFFFFFAAAA),
              child: Icon(Iconsax.notification, color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3649084504.
            onTap: () =>
                (allcontroller.userid.isEmpty) ? _showLogin() : showprofile(),
            child: CircleAvatar(
              child: Icon(Iconsax.user),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 250,
                decoration: const BoxDecoration(),
                child: PageView(
                  controller: _pageController,
                  children: [
                    promotionPage('assets/home1.jpg', 'Promo 1'),
                    promotionPage('assets/home2.jpeg', 'Promo 2'),
                    promotionPage('assets/home1.jpg', 'Promo 3'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Recommander',
                      style: TextStyle(fontSize: 19),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 320,
                      child: ListView.builder(
                        itemCount: allcontroller.produit.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          var produit = allcontroller.produit[index];
                          Color containerColor = Colors.grey.shade200;
                          containerColor =
                              allcontroller.stringToColor(produit['color']);
                          return Container(
                            height: 320,
                            width: 220,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () =>
                                      allcontroller.showProductBottomSheet(
                                          produit["idproduit"],
                                          context,
                                          "recommande"),
                                  child: Container(
                                      height: 240,
                                      width: 220,
                                      decoration: BoxDecoration(
                                          color: containerColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: CachedNetworkImage(
                                        imageUrl: produit["image"],
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        produit["nom"],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Prix : ' +
                                            ' ${produit["prix"].toString()} FCFA',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Catégories',
                      style: TextStyle(fontSize: 19),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: allcontroller.categorie.length,
                        itemBuilder: (BuildContext context, int index) {
                          var categorie = allcontroller.categorie[index];
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              radius: 35,
                              child:
                                  Image.asset("assets/${categorie['assets']}"),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemCount: allcontroller.produit.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var prod = allcontroller.produit[index];
                          Color containerColor = Colors.grey.shade200;
                          if (prod.containsKey('color')) {
                            containerColor =
                                allcontroller.stringToColor(prod['color']);
                          }
                          return Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () =>
                                      allcontroller.showProductBottomSheet(
                                          prod["idproduit"].toString(),
                                          context,
                                          "produit"),
                                  child: Container(
                                      height: (index.isEven ? 200 : 240),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: containerColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: CachedNetworkImage(
                                        imageUrl: prod['image'],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        prod['nom'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Prix : ' +
                                            ' ${prod["prix"].toString()} FCFA',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        })
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void _showLogin() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (BuildContext context) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [Login()],
            ));
      },
    );
  }

  Widget promotionPage(String imageUrl, String promoText) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl), // URL de l'image de promotion
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          padding: const EdgeInsets.all(10),
          child: Text(
            promoText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  showprofile() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        builder: (BuildContext context) {
          return Wrap(
            children: [Profil()],
          );
        });
  }
}

class Product {
  final String name;
  final Color color;
  final double price;
  final String image;

  Product(
      {required this.name,
      required this.color,
      required this.price,
      required this.image});
}
