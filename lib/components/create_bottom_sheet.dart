import 'package:flutter/material.dart';
import 'package:secretsanta/pages/creategroup.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController mnController = TextEditingController();
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
                  "Add member",
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
                keyboardType: TextInputType.number,
                controller: mnController,
                decoration: const InputDecoration(
                  labelText: "member no.",
                  hintText: "eg.1",
                ),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
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
                    dbReference.child(id).set({
                      'name': nameController.text.toString(),
                      'mn': mnController.text.toString(),
                      'email': emailController.text.toString(),
                      'id': id,
                    });
                    // For clearing the controllers
                    nameController.clear();
                    mnController.clear();
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
