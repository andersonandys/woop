import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/controller/allcontroler.dart';
import 'package:myapp/controller/databasecontroller.dart';
import 'package:myapp/videowidget.dart';

class Detailscreen extends StatefulWidget {
  const Detailscreen({Key? key}) : super(key: key);

  @override
  _DetailscreenState createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  var allcontroller = Get.put(Allcontroller());
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(100)),
              alignment: Alignment.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
            itemCount: allcontroller.produitselect.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var produit = allcontroller.produitselect[index];

              return Column(
                children: [
                  Center(
                    child: VideoPlayerWidget(
                        videoUrl: produit[
                            'video']), // Remplacez par l'URL de votre vidéo
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              produit['nom'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Chip(
                              side: BorderSide.none,
                              backgroundColor: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              label: Text(produit['etat']),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Prix : ${produit['prix'].toString()} FCFA',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[900],
                              ),
                            ),
                            Chip(
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              label: const Text('Fractionnee'),
                              avatar: Icon(Iconsax.buy_crypto),
                            )
                          ],
                        ),
                        Container(
                            color: Colors.grey.shade200,
                            padding: const EdgeInsets.all(5),
                            child: ListTile(
                              selected: true,
                              contentPadding: const EdgeInsets.all(0),
                              title: Text(
                                'Premier versement',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[900],
                                ),
                              ),
                              trailing: Text(
                                  '${produit['firstpaiement'].toString()} FCFA',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[900],
                                  )),
                            )),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            'Marque',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[900],
                            ),
                          ),
                          trailing: Text(produit['marque'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[900],
                              )),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            'Pointure',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[900],
                            ),
                          ),
                          trailing: Text(produit['pointure'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[900],
                              )),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          fixedSize: const Size.fromHeight(60),
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.green),
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      onPressed: () {
                                        addfavoris(produit);

                                        final snackBar = const SnackBar(
                                          content: Text(
                                              'This is a SnackBar inside BottomSheet'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Favoris',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Iconsax.heart_add,
                                              color: Colors.black)
                                        ],
                                      ))),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0XFFFFF4C4C),
                                          fixedSize: const Size.fromHeight(60),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      onPressed: () {
                                        addpanier(produit);
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Panier',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Iconsax.bag, color: Colors.white)
                                        ],
                                      )))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ],
      );
    }));
  }

  addfavoris(
    produit,
  ) {
    var userId = allcontroller.userid.value;
    FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('favoris')
        .add({
      'idproduit': produit['idproduit'],
      'nom': produit['nom'],
      'prix': produit['prix'],
      'firstpaiement': produit['firstpaiement'],
      'marque': produit['marque'],
      'pointure': produit['pointure'],
      'image': produit['image'],
      'color': produit['color'],
      'date_commande': FieldValue.serverTimestamp(),
      "range": DateTime.now().microsecondsSinceEpoch
    }).then((onValue) {
      Firestordata.FirestordataUser.doc(userId)
          .collection("favoris")
          .doc(onValue.id)
          .update({"idfavoris": onValue.id});
      allcontroller.messageerror(context, "Produit ajoute aux favoris");
    });
  }

  addpanier(produit) {
    var userId = allcontroller.userid.value;
    FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('panier')
        .add({
      'idproduit': produit['idproduit'],
      'nom': produit['nom'],
      'prix': produit['prix'],
      'firstpaiement': produit['firstpaiement'],
      'marque': produit['marque'],
      'pointure': produit['pointure'],
      'image': produit['image'],
      'color': produit['color'],
      'date_commande': FieldValue.serverTimestamp(),
      "range": DateTime.now().microsecondsSinceEpoch
    }).then((onValue) {
      Firestordata.FirestordataUser.doc(userId)
          .collection("panier")
          .doc(onValue.id)
          .update({"idpanier": onValue.id});
      allcontroller.messageerror(context, "Produit ajoute a votre panier");
    });
    Firestordata.FirestordataUser.doc(userId).update({
      "totalfirstpaiement": FieldValue.increment(produit['firstpaiement']),
      "totalpanier": FieldValue.increment(produit['prix'])
    });
  }
}
