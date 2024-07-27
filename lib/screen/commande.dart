import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controller/allcontroler.dart';

class Commande extends StatefulWidget {
  const Commande({Key? key}) : super(key: key);

  @override
  _CommandeState createState() => _CommandeState();
}

class _CommandeState extends State<Commande> {
  int activeStep = 0;

  double progress = 0.2;
  Set<int> reachedSteps = <int>{0, 2, 4, 5};

  final allcontroller = Get.put(Allcontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Obx(() {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  (allcontroller.commande.isEmpty)
                      ? Column(
                          children: [
                            Image.asset(
                              "assets/nolivraison.jpg",
                              height: 400,
                            ),
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
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allcontroller.commande.length,
                          itemBuilder: (context, index) {
                            var commandes = allcontroller.commande[index];
                            Color containerColor = Colors.grey.shade300;
                            containerColor =
                                allcontroller.stringToColor(commandes['color']);
                            return Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade100),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          allcontroller.showProductBottomSheet(
                                              commandes['idproduit'],
                                              context,
                                              "commande");
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: containerColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: commandes["image"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Container(
                                              child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Flexible(
                                                  child: Text(
                                                commandes['nom'],
                                                style: const TextStyle(
                                                    fontSize: 18),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Prix : ${commandes['prix']} ",
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Fraction :   ${commandes['firstpaiement']} ',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Marque :   ${commandes['marque']} ',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Pointure :   ${commandes['pointure']} ',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      )))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Etat de votre commande',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      height: 100,
                                      child: EasyStepper(
                                        activeStep: commandes['etat'],
                                        lineStyle: LineStyle(
                                          lineLength: 25,
                                          lineThickness: 6,
                                          lineSpace: 4,
                                          lineType: LineType.normal,
                                          defaultLineColor:
                                              Colors.purple.shade300,
                                          progress: progress,
                                          // progressColor: Colors.purple.shade700,
                                        ),
                                        borderThickness: 5,
                                        internalPadding: 5,
                                        // loadingAnimation: 'assets/loading_circle.json',
                                        steps: const [
                                          EasyStep(
                                            icon: Icon(CupertinoIcons.cart),
                                            title: 'Validée',
                                          ),
                                          EasyStep(
                                            icon: Icon(CupertinoIcons.info),
                                            title: 'Préparation ',
                                          ),
                                          EasyStep(
                                            icon: Icon(CupertinoIcons
                                                .cart_fill_badge_plus),
                                            title: 'En livraison',
                                          ),
                                          EasyStep(
                                              icon: Icon(
                                                  CupertinoIcons.money_dollar),
                                              title: 'Livrée',
                                              enabled: true),
                                        ],
                                        onStepReached: (index) {
                                          // allcontroller.updateOrderState(
                                          //     commandes['idcommande'], index);
                                        },
                                      ))
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ));
      })),
    );
  }
}
