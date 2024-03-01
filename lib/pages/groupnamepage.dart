import 'package:flutter/material.dart';
import 'package:secretsanta/components/elevatedbutton.dart';
import 'package:secretsanta/components/my_textfield.dart';
import 'package:secretsanta/pages/creategroup.dart';

class GroupName extends StatelessWidget {
  GroupName({Key? key});

  final groupName = TextEditingController();
  final textFieldData = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Secret Santa',
            style: TextStyle(color: Color.fromARGB(255, 210, 83, 83)),
          ),
          backgroundColor: const Color.fromARGB(240, 49, 29, 19),
          centerTitle: true,
        ),
        backgroundColor: const Color.fromARGB(255, 241, 233, 230),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // textfield
              MyTextField(
                  controller: textFieldData,
                  hintText: "e.g Johnson family",
                  obscureText: false),

              const SizedBox(height: 15),

              // confirm button
              MyButton2(
                text: "Confirm",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateGroup(name: textFieldData.text),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
}
