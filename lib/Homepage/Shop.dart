import 'dart:js_interop';

import 'package:app/Homepage/Items.dart';
import 'package:app/Providers/FavouriteCubit.dart';
import 'package:app/Providers/wishlist_provider.dart';
import 'package:app/services/Authentication.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:provider/provider.dart";
import 'package:app/services/Database.dart';
import "Wishlist.dart";
import 'cart.dart';

class Shop extends StatefulWidget {
  final String name;
  final String image;
  final int price;
  final String productID;

  final String user;

  const Shop({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
    required this.productID,
    required this.user
  }) : super(key: key);
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  late final col;

  int i=0;


  void initState(){
  col=BlocProvider.of<FavouriteCubit>(context);
  switch (widget.name){
  case "Sneakers" :
  i=0;
  break;
  case "T-shirts" :
  i=1;
  break;
  case "Bags":
  i=2;
  break;
  case "Heels" :
  i=3;
  break;
  case "Jackets" :
  i=4;
  break;
  case "Sunglasses" :
  i=5;
  break;
  }
  Dataservice(uid: widget.user).isAlreadyPresent(widget.productID).then((value) {
  if(value==1){
  print("val "+ value.toString());
  col.add(i);
  }
  });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: Text(
              "Shop the collection",
            ),
            titleTextStyle: TextStyle(color: Colors.black),
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            actions: [
               BlocBuilder<FavouriteCubit,List<int>>(
                 builder: (context,val) {
                   return IconButton(
                          icon: (val[i]==1)
                              ? Icon(
                            CupertinoIcons.heart_fill,
                            color: Colors.red,
                          )
                              : Icon(CupertinoIcons.suit_heart,
                              color: Colors.black),
                          onPressed: () async {

                            if(val[i]==0){
                   Dataservice(uid: widget.user).wishlist(
                   widget.productID,
                   widget.image,
                   widget.name,
                   widget.price);
                   print("added");
                   const snackBar2=SnackBar(content: Text("Added to Wishlist",style: TextStyle(color: Colors.white),),backgroundColor: Colors.green);
                   ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                   col.add(i);


                   }
                            else{
                              Dataservice(uid: widget.user).removewish(widget.productID);
                              const snackBar2=SnackBar(content: Text("Removed from Wishlist",style: TextStyle(color: Colors.white),),backgroundColor: Colors.green);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                              col.remove(i);
                   }


                 }
               );})]),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.all(20),
                    width: 400,
                    height: 250,
                    child:
                    Image.asset("assets/images/" + widget.image),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2, color: Colors.black))),
                SizedBox(height: 10),
                Text(widget.name.toUpperCase(),
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Rs." + "${widget.price}",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                SizedBox(height: 10),
                SizedBox(
                    height: 2,
                    child: Divider(
                      color: Colors.black,
                    )),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SIZE",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    TextButton(
                        onPressed: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey))),
                          child: Center(
                            child: Text("SIZE GUIDE",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                )),
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: SelSize(),
                ),
                SizedBox(
                    height: 2,
                    child: Divider(
                      color: Colors.black,
                    )),
                SizedBox(height: 10),
                Text("COLOR",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: SelColor(),
                ),
                SizedBox(
                    height: 2,
                    child: Divider(
                      color: Colors.black,
                    )),
                SizedBox(height: 10),
                Text("PRODUCT DETAILS",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                SizedBox(height: 5),
                Text("this is product details\nproductID:#mmmm"),
                SizedBox(height: 10),
                SizedBox(
                    height: 2,
                    child: Divider(
                      color: Colors.black,
                    )),
                SizedBox(height: 10),
                Text("Shipping and Returns",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                SizedBox(height: 5),
                Text(
                    "SHIPPING : delivery is expected by\nRETURN : return on this item"),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Material(
          child: TextButton(
              onPressed: () async {
                await Dataservice(uid: widget.user).cart(widget.productID,
                    widget.image, widget.name, widget.price, 28);
                print("added to cart");
                const snackBar2=SnackBar(content: Text("Added to Cart",style: TextStyle(color: Colors.white),),backgroundColor: Colors.green);
  ScaffoldMessenger.of(context).showSnackBar(snackBar2);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color(0Xffb7ea18),
                    borderRadius: BorderRadius.zero,
                    border: Border.all(
                        color: Colors.black,
                        width: 3,
                        style: BorderStyle.solid)),
                child: Center(
                  child: (false)
                      ? Text("ADDED TO CART",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          backgroundColor: Color(0Xffb7ea18),
                          color: Colors.black))
                      : Text("ADD TO CART",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          backgroundColor: Color(0Xffb7ea18),
                          color: Colors.black)),
                ),
              )),
        )
    );
  }
}
