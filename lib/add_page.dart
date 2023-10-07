import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPage extends StatelessWidget {
  AddPage({Key? key}) : super(key: key);

  String first = "";
  String last = "";
  int born = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'First',
              ),
              onChanged: (text) {
                first = text;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Last',
              ),
              onChanged: (text) {
                last = text;
              },
            ),
            TextField(
                decoration: const InputDecoration(
                  hintText: '1990',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (text) {
                  born = int.parse(text);
                },
            ),
            ElevatedButton(
              onPressed: () async {
                await _addToFirebase();
                Navigator.pop(context);
              },
              child: Text("Add to Firebase"),
            ),
          ],
        ),
      ),
    );
  }

  Future _addToFirebase() async {
    final db = FirebaseFirestore.instance;

    final user = <String, dynamic>{
      "first": first,
      "last": last,
      "born": born,
    };

// Add a new document with a generated ID
    await db.collection("users").add(user);
  }
}
