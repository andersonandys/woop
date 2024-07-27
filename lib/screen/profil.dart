import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/controller/allcontroler.dart';
import 'package:myapp/controller/databasecontroller.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final allcontroller = Get.put(Allcontroller());
  var numerocontroller = TextEditingController();
  var communecontroller = TextEditingController();
  var quartiercontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Obx(() {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15)),
                height: 5,
                width: 70,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15)),
                    height: 70,
                    width: 70,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('ID : ' + allcontroller.userid.value),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Code : IV' +
                          allcontroller.userid.value.substring(0, 4)),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(25),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200),
              child: Column(
                children: <Widget>[
                  const Center(
                    child: Text(
                      'Paiement Restant',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      allcontroller.usercredit.value.toString() + " FCFA",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  const Text('Montant restant pour vos paiement fractionnees'),
                  const SizedBox(
                    height: 20,
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
                                onPressed: () {},
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Tout payer',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                  ],
                                ))),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0XFFFFF4C4C),
                                    fixedSize: const Size.fromHeight(60),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onPressed: () {
                                  showfractionpaiement();
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Fractionner',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ],
                                )))
                      ],
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Iconsax.location),
              title: (allcontroller.commune.value.isEmpty)
                  ? const Text('Sauvegarder une adresse')
                  : const Text("Modifier l'adresse de livraison"),
              trailing: const Icon(Iconsax.arrow_right4),
              onTap: () {
                showsaveadress();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.money),
              title: (allcontroller.paiementnumber.value == 0)
                  ? const Text('Numero de paiement')
                  : const Text("Modifier le numeor de paiment"),
              trailing: const Icon(Iconsax.arrow_right4),
              onTap: () {
                showmethodepaiement();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_center_rounded),
              title: const Text('Centre d aide'),
              trailing: const Icon(Iconsax.arrow_right4),
              onTap: () {
                // le centre d aide doit envoyer directement vers whatsapp pour la prise en charge des users
              },
            )
          ],
        ),
      );
    }));
  }

  showfractionpaiement() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Paiement fractionne'),
          content: Wrap(
            children: [
              Column(
                children: <Widget>[
                  const Text(
                    'Payer la somme que vous pouvez pour reduire votre somme restant sans toute fois vous mettre de pression',
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200),
                      child: const TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 25),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(30),
                            hintText: "0.0 FCFA",
                            border: InputBorder.none),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          actions: [
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
                                  side: const BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Annuler',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ))),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0XFFFFF4C4C),
                              fixedSize: const Size.fromHeight(60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Valider',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          )))
                ],
              ),
            )
          ],
        );
      },
    );
  }

  showsaveadress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Adresse de livraison'),
          content: Wrap(
            children: [
              Column(
                children: <Widget>[
                  const Text(
                    'Ajouter en toute securite votre adresse pour la livraison de vos colis',
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200),
                    child: TextField(
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.number,
                      controller: numerocontroller,
                      decoration: InputDecoration(
                          hintText: "Numero", border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200),
                    child: TextField(
                      controller: communecontroller,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                          hintText: "Commune", border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200),
                    child: TextField(
                      controller: quartiercontroller,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                          hintText: "quartier", border: InputBorder.none),
                    ),
                  )
                ],
              )
            ],
          ),
          actions: [
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
                                  side: const BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2223997231.
                            Navigator.pop(context);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Annuler',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ))),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0XFFFFF4C4C),
                              fixedSize: const Size.fromHeight(60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {
                            if (numerocontroller.text.isEmpty ||
                                communecontroller.text.isEmpty ||
                                quartiercontroller.text.isEmpty) {
                              print("message");
                            } else {
                              Firestordata.FirestordataUser.doc(
                                      allcontroller.userid.value)
                                  .update({
                                "numero": numerocontroller.text,
                                "commune": communecontroller.text,
                                "quartier": quartiercontroller.text
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Valider',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          )))
                ],
              ),
            )
          ],
        );
      },
    );
  }

  showmethodepaiement() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Adresse de livraison'),
          content: Wrap(
            children: [
              Column(
                children: <Widget>[
                  const Text(
                    'Ajouter votre numero de paiement pour payer plus rapidement et profiter du paiment fractionee',
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(238, 238, 238, 1)),
                    child: TextField(
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.number,
                      controller: numerocontroller,
                      decoration: InputDecoration(
                          hintText: "Numero de paiement",
                          border: InputBorder.none),
                    ),
                  ),
                ],
              )
            ],
          ),
          actions: [
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
                                  side: const BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Annuler',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ))),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0XFFFFF4C4C),
                              fixedSize: const Size.fromHeight(60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {
                            if (numerocontroller.text.isEmpty) {
                            } else {
                              Firestordata.FirestordataUser.doc(
                                      allcontroller.userid.value)
                                  .update({
                                "paiementnumber":
                                    int.parse(numerocontroller.text)
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Valider',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          )))
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
