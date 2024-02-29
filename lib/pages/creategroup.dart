// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:secretsanta/components/create_bottom_sheet.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

final dbrefefence = FirebaseDatabase(
  databaseURL:
      'https://secretsantadb-ad295-default-rtdb.europe-west1.firebasedatabase.app/',
).reference();

class _CreateGroupState extends State<CreateGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 241, 233, 230),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(240, 49, 29, 19),
        centerTitle: true,
        title: const Text(
          'Secret Santa',
          style: TextStyle(color: Color.fromARGB(255, 210, 83, 83)),
        ),
      ),

      // For Create operation
      floatingActionButton: FloatingActionButton(
        onPressed: () => createBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
