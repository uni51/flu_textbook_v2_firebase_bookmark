import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class AddPage extends StatelessWidget {
  AddPage({Key? key}) : super(key: key);

  String first = "";
  String last = "";
  int born = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'First',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First Name（名）を入力してください';
                  }
                  return null;
                },
                onChanged: (text) {
                  first = text;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Last',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last Name（姓）を入力してください';
                  }
                  return null;
                },
                onChanged: (text) {
                  last = text;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: '1990',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '生まれた年を入力してください';
                  }
                  if (value.length != 4) {
                    return '4桁の西暦で入力してください';
                  }
                  if (int.parse(value) > DateTime.now().year ) {
                    return '過去の年で入力してください';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (text) {
                  born = int.parse(text);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _addToFirebase();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('更新しました')),
                    // );
                  }
                },
                child: Text("Add to Firebase"),
              ),
            ],
          ),
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
