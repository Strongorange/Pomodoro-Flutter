import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              title: const Text(
                'Setting',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0,
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: const [
                  Text('wow'),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: const [
                  Text('wow'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
