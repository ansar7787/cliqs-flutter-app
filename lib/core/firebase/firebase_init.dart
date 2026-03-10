import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

class FirebaseInit {
  static Future<void> init() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (e) {
      // Re-initialization often happens during Hot Restart.
      // We catch duplicate-app from crashing.
      if (!e.toString().contains('duplicate-app')) {
        rethrow;
      }
    }
  }
}
