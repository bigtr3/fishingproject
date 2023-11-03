import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishing/alarm.dart';
import 'package:fishing/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'auth_service.dart';
import 'bluetooth_search.dart';
import 'fishing_service.dart';
import 'login.dart';

class StopwatchApp extends StatefulWidget {
  @override
  State<StopwatchApp> createState() => _StopwatchAppState();
}

class _StopwatchAppState extends State<StopwatchApp> {
  String timeString = "00:00:00"; // 초기 값
  Stopwatch stopwatch = Stopwatch();
  late Timer timer;

// 스톱워치 시작 함수
  void start() {
    stopwatch.start();
    timer = Timer.periodic(Duration(milliseconds: 1), update);
  }

// 스톱워치의 시간을 업데이트 해주는 함수 (시간,분,초 나타냄)
  void update(Timer t) {
    if (stopwatch.isRunning) {
      setState(() {
        timeString =
            (stopwatch.elapsed.inHours % 60).toString().padLeft(2, "0") +
                ":" +
                (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
                ":" +
                (stopwatch.elapsed.inSeconds % 60)
                    .clamp(0, 99)
                    .toStringAsFixed(0)
                    .padLeft(2, "0");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<FishingService>(
      builder: (context, fishingService, child) {
        return Scaffold(
            backgroundColor: Colors.grey.shade200,

            // 앱바
            appBar: AppBar(
              title: Text('강태공', style: TextStyle(fontSize: 28)),
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 10, 60, 101),
            ),
            body: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    // 젤 위에 있는 글씨
                    padding: const EdgeInsets.all(30.0),
                    child: AutoSizeText(
                      "${user.email}님의 낚시 진행 시간",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      minFontSize: 18,
                      maxLines: 1,
                    ),
                  ),
                  // 가운데 타이머 (여기에 시간 표시)
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                        // 버튼과 배경색을 회색으로 설정하여 버튼 윗부분 명암 나타냄
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                        // 박스 그림자
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(10, 10),
                              color: Colors.blueGrey,
                              blurRadius: 15),
                          BoxShadow(
                              offset: Offset(-10, -10),
                              color: Colors.white.withOpacity(0.85),
                              blurRadius: 15)
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // 가운데 낚시 이모티콘
                          child: Text("\u{1f3a3}",
                              style: TextStyle(
                                fontSize: 80,
                              )),
                        ),
                        // 글씨는 timeString으로 설정
                        Text(timeString,
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.grey.shade900,
                            ))
                      ],
                    ),
                  ),

                  // 밑에 버튼 2개
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        // 첫번째 버튼 종료하기
                        TextButton(
                            onPressed: () {
                              fishingService.create(
                                  user.email!, Timestamp.now(), timeString);
                              // 홈페이지로 이동
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                              showEnd(); // 토스트 메세지
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(10, 10),
                                        color: Colors.blueGrey,
                                        blurRadius: 15),
                                    BoxShadow(
                                        offset: Offset(-10, -10),
                                        color: Colors.white.withOpacity(0.85),
                                        blurRadius: 15)
                                  ]),
                              child: Center(
                                // x 아이콘 (필요에 따라 텍스트로 대체 가능)
                                child: Icon(
                                  CupertinoIcons.clear,
                                  size: 60,
                                  color: Color.fromARGB(255, 10, 60, 101),
                                ),
                              ),
                            )),

                        // 두 번째 버튼 (시작하기)
                        TextButton(
                            onPressed: () {
                              start();
                              showStart(); // 토스트 메세지
                              Timer(Duration(seconds: 10), () => {Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AlarmPage(
                                          title: '강태공',
                                        )), // 이동하려는 페이지
                              )});
                              // 버튼 누르면 스톱워치 시작
                              //sleep(Duration(seconds: 10));
                              
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(10, 10),
                                        color: Colors.blueGrey,
                                        blurRadius: 15),
                                    BoxShadow(
                                        offset: Offset(-10, -10),
                                        color: Colors.white.withOpacity(0.85),
                                        blurRadius: 15)
                                  ]),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.arrowtriangle_right_fill,
                                  size: 60,
                                  color: Color.fromARGB(255, 17, 91, 152),
                                ),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}

void showStart() {
  Fluttertoast.showToast(
    msg: '낚시를 시작합니다.',
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void showEnd() {
  Fluttertoast.showToast(
    msg: '낚시를 종료합니다.',
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_SHORT,
  );
}