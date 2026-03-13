import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../utils/route/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GetStorage storage = GetStorage();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() {
    bool isLogin = storage.read('isLogin') ?? false;

    Timer(const Duration(seconds: 2), () {
      if (isLogin) {
        Navigator.pushReplacementNamed(context, RouteName.home);
      } else {
        Navigator.pushReplacementNamed(context, RouteName.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.newspaper, size: 80, color: Colors.blue),

            SizedBox(height: 20),

            Text(
              "News Intelligence",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
