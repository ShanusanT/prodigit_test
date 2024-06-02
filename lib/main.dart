import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prodigit_test/screens/home_page.dart';
import 'package:prodigit_test/screens/login_page.dart';
import 'package:prodigit_test/utils/colors.dart';
import 'dart:io';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();



  await Firebase.initializeApp(
      options:  Platform.isAndroid ? const FirebaseOptions(
        apiKey: 'AIzaSyAqmXj2JlLEK1iQmlyRYz8ZINtJXsgRvbs',
        appId: '1:777739309208:android:0675d095aa526c663840ed',
        messagingSenderId: '777739309208',
        projectId: 'prodigit-test',
        storageBucket: 'prodigit-test.appspot.com',
      ) : const FirebaseOptions(
        apiKey: 'AIzaSyAT-PPTQrCc30FJqPo4ZHzOv4dMxswIO5Y',
        appId: '1:777739309208:ios:fc3a0bb0793dda533840ed',
        messagingSenderId: '777739309208',
        projectId: 'prodigit-test',
        storageBucket: 'prodigit-test.appspot.com',
        iosBundleId: 'com.prodigittest.prodigitTest',
        iosClientId: '777739309208-2r5de0dtggvjdqep6bf0un4crh9gm26p.apps.googleusercontent.com',
        androidClientId: '777739309208-a7njhebkt0m6mjjn3ahfbuoi6i9v1ski.apps.googleusercontent.com'
      )
  );
  runApp(const TestApp());
}





class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProDigit Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: brandColor),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}







class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}
