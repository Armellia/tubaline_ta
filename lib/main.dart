import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tubaline_ta/providers/loading_provier.dart';
import 'package:tubaline_ta/providers/search_provider.dart';
import 'package:tubaline_ta/providers/personal_information_provider.dart';
import 'package:tubaline_ta/services/service_profile.dart';
import 'package:tubaline_ta/services/service_user.dart';

import 'package:tubaline_ta/widgets/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ServiceUser serviceUser = ServiceUser();
  ServiceProfile serviceProfile = ServiceProfile();
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
        ChangeNotifierProvider<LoadingProvider>(
            create: (_) => LoadingProvider()),
        ChangeNotifierProvider<PersonalProvider>(
            create: (_) => PersonalProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
