import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserStocksProvider with ChangeNotifier {
  FirebaseFirestore firestore;
  String userID;
  UserStocksProvider(this.userID) {
    firestore = FirebaseFirestore.instance;
  }

  Stream<QuerySnapshot> get transactions => firestore
      .collection('transactions')
      .where('userID', isEqualTo: userID)
      .snapshots();
  // Stream get userBalance =>
  //     firestore.collection('users').where('userID' == userID).snapshots();
}
