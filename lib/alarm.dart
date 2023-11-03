import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key, required this.title});

  final String title;

  @override
  State<AlarmPage> createState() => _AlarmPage();
}

class _AlarmPage extends State<AlarmPage> {
  bool isVibrating = false;

  @override
  void initState() {
    super.initState();
    _toggleVibration();
  }

  void _toggleVibration() async {
    if (isVibrating) {
      //진동이 울리고 있다면 진동 종료
      Vibration.cancel();
    } else {
      // 진동 울리기 (1000ms = 1초)
      Vibration.vibrate(pattern: [
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
        1000,
      ]);
    }
    setState(() {
      isVibrating = !isVibrating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('강태공', style: TextStyle(fontSize: 28)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 10, 60, 101),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.done,
              size: 100,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '입질 감지\n확인해주세요!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 32,
            ),
            ElevatedButton(
                onPressed: () {
                  _toggleVibration();
                },
                child: Text(isVibrating ? '진동 끄기' : '진동 켜기'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 17, 91, 152),
                )),
          ],
        ),
      ),
    );
  }
}