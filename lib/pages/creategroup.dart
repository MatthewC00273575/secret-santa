import 'package:flutter/material.dart';

class CreateGroup extends StatelessWidget {
  const CreateGroup({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Secret Santa',
            style: TextStyle(color: Color.fromARGB(255, 210, 83, 83)),
          ),
          backgroundColor: Color.fromARGB(240, 49, 29, 19),
          centerTitle: true,
        ),
        backgroundColor: const Color.fromARGB(255, 241, 233, 230),
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(20),
            ),
            child: Text('Last Screen', style: TextStyle()),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
}
