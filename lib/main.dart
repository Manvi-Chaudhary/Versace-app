import 'package:app/Providers/FavouriteCubit.dart';
import 'package:app/Providers/wishlist_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/Authentication.dart';
import 'package:provider/provider.dart';
import 'services/Authentication.dart';
import 'services/Database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{

    const firebaseconfig = FirebaseOptions(
        apiKey: "AIzaSyDV4zKh-MsrUi7YowLZRiRG9PySxYuoQbQ",
        appId: "1:216493400994:android:427055c1623d779b6ec8fb",
        messagingSenderId: "216493400994",
        projectId: "versace-app-614f6");
    await Firebase.initializeApp(options: firebaseconfig);
    print("hii manvi");
  }
  catch(e){
    print("error manvi : "+ e.toString());
  }

  runApp(MyApp());
}

class Mapp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home:Container(
        child: Center(child: Text("hii"),),
      )
    );
  }
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider.value(value: Authservice().user, initialData: null),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
          BlocProvider(create: (_)=>FavouriteCubit())
        ],
        child: MaterialApp(
          // Application name
          title: 'Versace App',

          // Application theme data, you can set the colors for the application as
          // you want
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: "Hanken Grotesk",
          ),
          // A widget which will be started on application startup
          home: Wrapper(),
        ));
  }
}
