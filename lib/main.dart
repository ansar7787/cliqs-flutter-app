import 'package:flutter/material.dart';
import 'app.dart';
import 'core/firebase/firebase_init.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseInit.init();

  // Initialize Dependency Injection
  await di.init();

  runApp(const MyApp());
}
