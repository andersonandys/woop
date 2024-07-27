import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/controller/allcontroler.dart';
import 'package:myapp/controller/databasecontroller.dart';
import 'package:myapp/screen/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Connexion extends StatefulWidget {
  const Connexion({Key? key}) : super(key: key);

  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  String error = "";
  var load = false;
  final allcontroller = Get.put(Allcontroller());
  TextEditingController password = TextEditingController();
  String errors = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Container(
                  height: 5,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Connectez-vous a votre en rentrant votre mot de passe ',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: password,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      hintText: "Mot de passe", border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              if (errors.isNotEmpty)
                Text(
                  errors,
                  style: TextStyle(color: Colors.red),
                ),
              if (errors.isNotEmpty)
                const SizedBox(
                  height: 30,
                ),
              if (load)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (!load)
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
                      connexion();
                    },
                    child: const Text(
                      'Connexion',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  connexion() async {
    setState(() {
      load = true;
    });
    if (password.text.isEmpty) {
      setState(() {
        errors = "Saisisez votre mot de passe";
        load = false;
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      Firestordata.FirestordataUser.where("password", isEqualTo: password.text)
          .get()
          .then((value) async {
        if (value.docs.isEmpty) {
          setState(() {
            errors = "Mot de passe incorrecte";
            load = false;
          });
        } else {
          await prefs.setString('user_uid', value.docs.first['userid']);
          allcontroller.userid.value = value.docs.first['userid'];
          allcontroller.getuser();
          setState(() {
            load = false;
          });

          Navigator.pop(context);
          allcontroller.messageerror(context, "Vous etes bien connecter");
        }
      });
    }
  }
}
