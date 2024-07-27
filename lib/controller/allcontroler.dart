import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controller/databasecontroller.dart';
import 'package:myapp/screen/detailscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Allcontroller extends GetxController {
  var userid = "".obs;
  var username = "".obs;
  var photourl = "".obs;
  var mail = "".obs;
  var wallet = 0.obs;
  var numero = "".obs;
  var commune = "".obs;
  var quartier = "".obs;
  var paiementnumber = 0.obs;
  var orders = <Map<String, dynamic>>[].obs;
  var commande = <Map<String, dynamic>>[].obs;
  var favoris = <Map<String, dynamic>>[].obs;
  var produit = <Map<String, dynamic>>[].obs;
  var produitselect = <Map<String, dynamic>>[].obs;
  var panier = <Map<String, dynamic>>[].obs;
  var notifications = <Map<String, dynamic>>[].obs;
  var categorie = <Map<String, dynamic>>[].obs;
  var usercredit = 0.obs;
  var totalpanier = 0.obs;
  var firstpaiment = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getuser();
  }

  void getuser() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('user_uid');
    listenToProduct();
    listenToCategorie();
    if (uid != null) {
      userid.value = uid;
      listenToUserChanges(uid);
      listenToOrders(uid);
      listenToCommande(uid);
      listenToFavoris(uid);
      listenToPanier(uid);
      listenToNotification(uid);
    } else {
      // Rediriger l'utilisateur vers la page de connexion si l'UID n'est pas trouvé
      // Utilisez votre route pour la page de connexion
    }
  }

  void listenToUserChanges(String uid) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null) {
          username.value = data['username'] ?? '';
          photourl.value = data['photourl'] ?? '';
          mail.value = data['email'] ?? '';
          wallet.value = data['wallet'] ?? 0;
          numero.value = data['numero'] ?? '';
          commune.value = data['commune'] ?? '';
          quartier.value = data['quartier'] ?? '';
          paiementnumber.value = data['paiementnumber'] ?? 0;
          totalpanier.value = data['totalpanier'] ?? 0;
          firstpaiment.value = data['totalfirstpaiement'] ?? 0;
          usercredit.value = data['usercredit'] ?? 0;
        }
      }
    });
  }

  void listenToOrders(String uid) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('orders')
        .snapshots()
        .listen((querySnapshot) {
      orders.value = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  void listenToNotification(String uid) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('notification')
        .snapshots()
        .listen((querySnapshot) {
      notifications.value = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  void listenToCommande(String uid) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('commande')
        .snapshots()
        .listen((querySnapshot) {
      commande.value = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  void listenToPanier(String uid) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('panier')
        .snapshots()
        .listen((querySnapshot) {
      panier.value = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  void listenToFavoris(String uid) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('favoris')
        .snapshots()
        .listen((querySnapshot) {
      favoris.value = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['docId'] = doc.id; // Ajouter l'ID du document
        return data;
      }).toList();
    });
  }

  void listenToProduct() {
    FirebaseFirestore.instance
        .collection('produit')
        .snapshots()
        .listen((querySnapshot) {
      produit.value = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  void listenToCategorie() {
    FirebaseFirestore.instance
        .collection('categorie')
        .orderBy("rang")
        .snapshots()
        .listen((querySnapshot) {
      categorie.value = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  void listenToProductforid(String idproduit) {
    print("object");
    FirebaseFirestore.instance
        .collection('produit')
        .where("idproduit", isEqualTo: idproduit)
        .snapshots()
        .listen((querySnapshot) {
      produitselect.value = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  messageerror(context, message) {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Succes',
        message: message,

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Color stringToColor(String colorString) {
    int value = int.parse(colorString);
    return Color(value);
  }

  addfavoris(idproduit, context) {
    Firestordata.FirestordataUser.doc(userid.value).collection("favoris").add({
      "idproduit": idproduit,
      // "range": DateTime.now().microsecondsSinceEpoch,
    }).then((value) {
      print("test de voir");
      print(value.id);
      Firestordata.FirestordataUser.doc(userid.value)
          .collection("favoris")
          .doc(value.id)
          .update({
        "idfavoris": value.id,
      });
    });
    //messageerror(context, "Produit ajoute aux favoris");
  }

  void showProductBottomSheet(String idproduit, context, type) {
    listenToProductforid(idproduit);
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (BuildContext context) {
        return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Wrap(
              children: [Detailscreen()],
            ));
      },
    );
  }

  addpanier(idproduit, context) {
    Firestordata.FirestordataUser.doc(userid.value).collection("panier").add({
      "idproduit": idproduit,
      "range": DateTime.now(),
    }).then((value) {
      Firestordata.FirestordataUser.doc(userid.value)
          .collection("panier")
          .doc(value.id)
          .update({
        "idpanier": value.id,
      });
    });
  }

  void updateOrderState(String orderId, int newState) async {
    print(orderId);
    print('object');
    String userId = userid.value;
    await FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .collection("commande")
        .doc(orderId)
        .update({"etat": newState});
  }
}
