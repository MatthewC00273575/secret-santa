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
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 75.0),
            child: Text(
              'Secret Santa',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 28, 28, 28),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
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
