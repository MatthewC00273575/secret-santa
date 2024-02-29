import 'package:flutter/material.dart';
import 'package:secretsanta/pages/creategroup.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController snController = TextEditingController();
final TextEditingController emailController = TextEditingController();

void createBottomSheet(BuildContext context) {
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 241, 233, 230),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  "Create your items",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "eg.Cristiano",
                ),
              ),
              TextField(
                controller: snController,
                decoration: const InputDecoration(
                  labelText: "S.N",
                  hintText: "eg.Ronaldo",
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "email",
                  hintText: "eg.ron@gmail.com",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    final id = DateTime.now().microsecond.toString();
                    dbrefefence.child(id).set({
                      'name': nameController.text.toString(),
                      'sn': snController.text.toString(),
                      'email': emailController.text.toString(),
                      'id': id,
                    });
                    // For Read/Display operation

                    // For clear the controller
                    nameController.clear();
                    snController.clear();
                    emailController.clear();
                    // dismiss keyboard after adding items
                    Navigator.pop(context);
                  },
                  child: const Text("add"))
            ],
          ),
        );
      });
}
