import 'package:flutter/material.dart';
import 'package:secretsanta/components/elevatedbutton.dart';
import 'package:secretsanta/components/my_textfield.dart';
import 'package:secretsanta/pages/create_group_details.dart';

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
              Container(
                padding: const EdgeInsetsDirectional.all(20),
                decoration:
                    const BoxDecoration(color: Color.fromARGB(255, 75, 75, 75)),
                child: const Text(
                  'Give your group a name!',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 25),

              // textfields
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
                      builder: (context) => const CreateGroupDetails(),
                    ),
                  );
                },
                iconData: Icons.arrow_right,
              )
            ],
          ),
        ),
      );
}
