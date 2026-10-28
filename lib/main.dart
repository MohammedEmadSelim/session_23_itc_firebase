import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:session_23_itc_firebase/cubits/home_cubit/home_cubit.dart';
import 'package:session_23_itc_firebase/screens/home_screen.dart';
import 'package:session_23_itc_firebase/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyDtBQBrkJ0dT9GFpG4rwX0ZafcvAy85cOc',
        appId: '1:109028761168:web:9820184f79aa8a8eaafb55',
        messagingSenderId: '109028761168',
        projectId: 'session-22-itc',
        authDomain: 'session-22-itc.firebaseapp.com',
        storageBucket: 'session-22-itc.firebasestorage.app',
        measurementId: 'G-3LYPVGJ3HQ',
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? BlocProvider(
        create: (context) => HomeCubit(),
        child: HomeScreen(),
      )
          : LoginScreen(),
    );
  }
}
