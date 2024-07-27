import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/controller/allcontroler.dart';

class Favoris extends StatefulWidget {
  const Favoris({Key? key}) : super(key: key);

  @override
  _FavorisState createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  final allcontroller = Get.put(Allcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  if (allcontroller.favoris.isEmpty)
                    Column(
                      children: [
                        Image.asset(
                          "assets/nofavoris.jpeg",
                          height: 400,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Vous n'avez pas de produit favoris ajouté",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allcontroller.favoris.length,
                      itemBuilder: (context, index) {
                        var favori = allcontroller.favoris[index];
                        Color containerColor = Colors.grey.shade200;
                        containerColor =
                            allcontroller.stringToColor(favori['color']);
                        return Container(
                          height: 200,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: containerColor,
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: GestureDetector(
                                onTap: () =>
                                    allcontroller.showProductBottomSheet(
                                        favori['idproduit'], context,'favoris'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    favori['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              favori['nom'],
                                              style:
                                                  const TextStyle(fontSize: 18),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showRemoveConfirmationDialog(
                                                  favori['idfavoris']);
                                            },
                                            child: const Icon(Iconsax.trash,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Prix : ${favori['prix']}F',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Fraction : ${favori['firstpaiement']}F',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Marque : ${favori['marque']}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Pointure : ${favori['pointure']}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          })),
    );
  }

  void _showRemoveConfirmationDialog(String favorisDocId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Retirer le produit'),
          content: const Text('Voulez-vous vraiment retirer du panier?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () {
                print(favorisDocId);
                FirebaseFirestore.instance
                    .collection("user")
                    .doc(allcontroller.userid.value)
                    .collection("favoris")
                    .doc(favorisDocId)
                    .delete()
                    .then((_) {
                  allcontroller.messageerror(
                      context, "Produit retiré des favoris avec succès");
                });
              },
            ),
          ],
        );
      },
    );
  }
}
