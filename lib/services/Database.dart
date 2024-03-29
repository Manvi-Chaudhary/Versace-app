import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dataservice {
  String uid = "";
  Dataservice({required this.uid});

  CollectionReference record = FirebaseFirestore.instance.collection("data");

  Future cred(String email, String username, String password) async {
    return await record
        .doc(uid)
        .set({"Email": email, "Username": username, "Password": password});
  }

  Future cart(
    String productID,
    String image,
    String name,
    int price,
    int size,
  ) async {
    return await record.doc(uid).collection("Cart").doc(productID).set({
      "ProductID": productID,
      "Image": image,
      "Name": name,
      "Price": price,
      "Size": size,
    });
  }

  Future wishlist(
    String productID,
    String image,
    String name,
    int price,
  ) async {
    try {
      return await record.doc(uid).collection("Wishlist").doc(productID).set({
        "ProductID": productID,
        "Image": image,
        "Name": name,
        "Price": price,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future removewish(id) async {
    try {
      return await record.doc(uid).collection("Wishlist").doc(id).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future removecart(id) async {
    return await record.doc(uid).collection("Cart").doc(id).delete();
  }

  Future isAlreadyPresent(String productID) async {
    try{
      QuerySnapshot s = await record
          .doc(uid)
          .collection("Wishlist")
          .where("ProductID", isEqualTo: productID)
          .get();
      return s.size;

    }
    catch(e){
      return null;
    }


  }

  Stream<QuerySnapshot> get wish {
    return record.doc(uid).collection("Wishlist").snapshots();
  }

  Stream<QuerySnapshot> get cartItems {
    return record.doc(uid).collection("Cart").snapshots();
  }

  Future<String?> checkcart(String productID) async {
    QuerySnapshot s = await record
        .doc(uid)
        .collection("Cart")
        .where("ProductID", isEqualTo: productID)
        .get();
    if (s.docs == []) {
      return null;
    }
    return "ADDED TO CART";
  }

  Future<String?> checkwish(String productID) async {
    QuerySnapshot s = await record
        .doc(uid)
        .collection("Wishlist")
        .where("ProductID", isEqualTo: productID)
        .get();
    if (s.docs == []) {
      return null;
    }
    return s.docs[0].id;
  }

  Future<String?> getemail(String username, String password) async {
    QuerySnapshot s = await record
        .where("Username", isEqualTo: username)
        .where("Password", isEqualTo: password)
        .get();
    if (s.docs == []) {
      return null;
    }
    return s.docs[0]["Email"];
  }
}
