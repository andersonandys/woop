import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/controller/allcontroler.dart';
import 'package:myapp/controller/databasecontroller.dart';

class Panier extends StatefulWidget {
  Panier({Key? key}) : super(key: key);

  @override
  _PanierState createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  final allcontroller = Get.put(Allcontroller());
  double totalAPayer = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: (allcontroller.panier.isEmpty)
              ? Column(
                  children: [
                    Image.asset("assets/nocommande1.jpg"),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Vous n'avez pas de produit dans votre panier",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.justify,
                    )
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: allcontroller.panier.length,
                        itemBuilder: (context, index) {
                          var panier = allcontroller.panier[index];
                          Color containerColor = Colors.grey.shade200;
                          containerColor =
                              allcontroller.stringToColor(panier['color']);

                          return Container(
                            height: 200,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        allcontroller.showProductBottomSheet(
                                            panier['idproduit'],
                                            context,
                                            "panier"),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: containerColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: panier['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
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
                                              panier['nom'],
                                              style:
                                                  const TextStyle(fontSize: 18),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showRemoveConfirmationDialog(
                                                  panier['idpanier'],
                                                  panier['prix'],
                                                  panier["firstpaiement"]);
                                            },
                                            child: const Icon(Iconsax.trash,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Prix : ${panier['prix']}F',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Fraction : ${panier['firstpaiement']}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Marque : ${panier['marque']}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Pointure : ${panier['pointure']}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              "Premier paiement",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(
                              "${allcontroller.firstpaiment} fcfa",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              "Total à payer",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            trailing: Text(
                              "${allcontroller.totalpanier.value} fcfa",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black.withBlue(30),
                                fixedSize: const Size.fromHeight(60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                addcommande();
                              },
                              child: const Text(
                                'Valider ma commande',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        );
      })),
    );
  }

  void _showRemoveConfirmationDialog(String docId, prix, fraction) {
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
                FirebaseFirestore.instance
                    .collection("user")
                    .doc(allcontroller.userid.value)
                    .collection("panier")
                    .doc(docId)
                    .delete()
                    .then((_) {
                  Firestordata.FirestordataUser.doc(allcontroller.userid.value)
                      .update({
                    "totalfirstpaiement": FieldValue.increment(-fraction),
                    "totalpanier": FieldValue.increment(-prix)
                  });
                  allcontroller.messageerror(
                      context, "Produit retiré du panier avec succès");
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void addcommande() async {
    try {
      var userId = allcontroller.userid.value;
      var panier = allcontroller.panier;

      for (var item in panier) {
        String idproduit = item['idproduit'];
        DocumentSnapshot produitDoc = await FirebaseFirestore.instance
            .collection('produit')
            .doc(idproduit)
            .get();

        if (produitDoc.exists) {
          var produitData = produitDoc.data() as Map<String, dynamic>;

          // Ajouter l'élément du panier à la collection commande de l'utilisateur
          await FirebaseFirestore.instance
              .collection('user')
              .doc(userId)
              .collection('commande')
              .add({
            'idproduit': idproduit,
            'nom': produitData['nom'],
            'prix': produitData['prix'],
            'firstpaiement': produitData['firstpaiement'],
            'marque': produitData['marque'],
            'pointure': produitData['pointure'],
            'image': produitData['image'],
            'color': produitData['color'],
            'date_commande': FieldValue.serverTimestamp(),
            "etat": 0
          }).then((onValue) {
            Firestordata.FirestordataUser.doc(userId)
                .collection("commande")
                .doc(onValue.id)
                .update({"idcommande": onValue.id});
          });
          Firestordata.FirestordataUser.doc(userId).update({
            "usercredit": FieldValue.increment(produitData['firstpaiement'])
          });
          // Supprimer l'élément du panier après l'ajout à la commande
          await FirebaseFirestore.instance
              .collection("user")
              .doc(userId)
              .collection("panier")
              .doc(item['idpanier'])
              .delete();
        }
      }

      // Vider le panier localement après avoir enregistré tous les éléments
      allcontroller.panier.clear();

      // Afficher un message de succès
      allcontroller.messageerror(
          context, "Commande validée avec succès et panier vidé");
    } catch (e) {
      // Afficher un message d'erreur en cas d'échec
      allcontroller.messageerror(
          context, "Erreur lors de la validation de la commande");
    }
  }
}
