import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secretsanta/components/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:secretsanta/models/dynamic_link.dart';
import 'package:secretsanta/models/shop.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DynamicLinkProvider().initDynamicLink();

  runApp(ChangeNotifierProvider(
    create: (context) => Shop(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
