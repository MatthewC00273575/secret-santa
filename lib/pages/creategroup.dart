// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:secretsanta/components/create_bottom_sheet.dart';
import 'package:secretsanta/components/update_bottom_sheet.dart';

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
      // For Read/Display operation
      body: Column(
        children: [
          Expanded(
              child: FirebaseAnimatedList(
                  query: dbrefefence,
                  itemBuilder: (context, snapshot, index, animation) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                          title: Text(
                            snapshot
                                .child("name")
                                .value
                                .toString(), //get a single value from db
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          subtitle:
                              Text(snapshot.child("email").value.toString()),
                          leading: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 170, 230, 115),
                              child:
                                  Text(snapshot.child("mn").value.toString())),
                          trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                    // For update operation
                                    PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          updateBottomSheet(
                                            context,
                                            snapshot
                                                .child("name")
                                                .value
                                                .toString(),
                                            snapshot
                                                .child("id")
                                                .value
                                                .toString(),
                                            snapshot
                                                .child("mn")
                                                .value
                                                .toString(),
                                            snapshot
                                                .child("email")
                                                .value
                                                .toString(),
                                          );
                                        },
                                        leading: const Icon(Icons.edit),
                                        title: const Text("edit"),
                                      ),
                                    ),
                                    // For the delete
                                    PopupMenuItem(
                                      value: 2,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(
                                              context); // close sheet when done
                                          dbrefefence
                                              .child(snapshot
                                                  .child('id')
                                                  .value
                                                  .toString())
                                              .remove();
                                        },
                                        leading: const Icon(Icons.delete),
                                        title: const Text("delete"),
                                      ),
                                    ),
                                  ])),
                    );
                  })),
        ],
      ),
      // For Create operation
      floatingActionButton: FloatingActionButton(
        onPressed: () => createBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
