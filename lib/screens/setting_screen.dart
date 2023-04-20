import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/components/square_card.dart';
import 'package:pomodoro_flutter/utils/time_utils.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void handleChangeMinutes(int minutes) {
    TimeClass.setTotalSeconds(minutes * 60);
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBE8DD),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 10.0),
                      child: Text(
                        'Timer',
                        style: TextStyle(fontSize: 24.0, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SquareCard(
                          mainText: '25',
                          subText: 'SESSIONS',
                          handleChangeMinutes: () => handleChangeMinutes(25),
                        ),
                        SquareCard(
                          mainText: '5',
                          subText: 'SHORT BREAKS',
                          handleChangeMinutes: () => handleChangeMinutes(5),
                        ),
                        SquareCard(
                          mainText: '15',
                          subText: 'LONG BREAKS',
                          handleChangeMinutes: () => handleChangeMinutes(15),
                        ),
                      ],
                    ),
                  ),
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
