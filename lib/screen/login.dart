import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/controller/allcontroler.dart';
import 'package:myapp/controller/databasecontroller.dart';
import 'package:myapp/screen/connexion.dart';
import 'package:myapp/screen/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String error = "";
  var load = false;
  final allcontroller = Get.put(Allcontroller());
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 5,
              width: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), color: Colors.grey),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Connectez-vous avec votre compte pour profiter pleinement des achats en illimité avec le paiement fractionné en toute sécurité',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 30,
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
                  Navigator.pop(context);

                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    builder: (BuildContext context) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            children: [Connexion()],
                          ));
                    },
                  );
                },
                child: const Text(
                  'Connexion systematique',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(width: 2, color: Colors.black),
                  fixedSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  inscription();
                },
                child: const Text(
                  'Inscription systematique',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _storeUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uid', uid);
  }

  void inscription() async {
    setState(() {
      load = true;
    });
    final prefs = await SharedPreferences.getInstance();
    Firestordata.FirestordataUser.add({
      'username': "",
      'email': "",
      'photourl': "",
      'number ': "",
      "userid": "",
      "wallet": 0,
      "numero": "",
      "commune": "",
      "quartier": "",
      "paiementnumber": 0,
      "password": "",
      "totalpanier": 0,
      "totalfirstpaiement": 0,
      "usercredit": 0
    }).then((values) async {
      print(values.id);

      await prefs.setString('user_uid', values.id);
      allcontroller.userid.value = values.id;

      Firestordata.FirestordataUser.doc(values.id)
          .update({"userid": values.id});
      allcontroller.getuser();
      setState(() {
        load = false;
      });

      Navigator.pop(context);

      showmethodepaiement(values.id);
    }).catchError((e) {
      print(e);
    });
  }

  showmethodepaiement(iduser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Compte creer avec sucess'),
          content: Wrap(
            children: [
              Column(
                children: <Widget>[
                  const Text(
                    'Votre compte a ete creer avec sucess, nous vous prions de renseigner un mot de passe pour la securiter de votre compte',
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
                      controller: password,
                      obscureText: true,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                          hintText: "Mot de passe", border: InputBorder.none),
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
                            if (password.text.isEmpty) {
                            } else {
                              Firestordata.FirestordataUser.doc(
                                      allcontroller.userid.value)
                                  .update({"password": password.value.text});
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
