import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hikedex/auth/auth.dart';
import 'package:hikedex/firebase_options.dart';
import 'package:hikedex/utils/textloader.dart';
import 'package:provider/provider.dart';
import 'package:hikedex/pages/home/home.dart';
import 'package:hikedex/providers/apiProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Ideal time to initialize
  // await FirebaseAuth.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApiProvider(),
      child: MaterialApp(
        // Routes
        routes: {
          '/': (context) => const Home(),
          '/auth': (context) => const AuthPage(),
          // '/selectArea': (context) => const SelectArea(),
        },
        title: 'Hikedex',
        initialRoute: '/auth',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          textTheme: CustomText.textTheme(const TextTheme()),
          colorSchemeSeed: Colors.blueGrey,
          switchTheme: SwitchThemeData(
            thumbIcon: MaterialStateProperty.resolveWith(
              (states) => Icon(
                states.contains(MaterialState.selected)
                    ? Icons.check
                    : Icons.close,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
