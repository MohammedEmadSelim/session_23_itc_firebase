import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:session_23_itc_firebase/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(
                  hintText: "body",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 16,
              ),

              ElevatedButton(
                onPressed: () {
                  var firestore = FirebaseFirestore.instance;

                  firestore.collection("users").add({
                    "title": _titleController.text,
                    "body": _bodyController.text,
                  });
                },
                child: Text("Add Todo", style: TextStyle(color: Colors.green)),
              ),

              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then(
                    (value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) {
                        return false;
                      },
                    ),
                  );
                },
                child: Text("Sign Out "),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
