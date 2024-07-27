import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Firestordata {
  static final FirestordataUser = FirebaseFirestore.instance.collection('user');
  static final FirestordataFavoris =
      FirebaseFirestore.instance.collection('favoris');
}
