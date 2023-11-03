import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishing/stopwatch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'fishing_service.dart';
import 'login.dart';

/// 홈페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<FishingService>(
      builder: (context, fishingService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("낚시 기록"),
            actions: [
              TextButton(
                child: Text(
                  "로그아웃",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  // 로그아웃
                  context.read<AuthService>().signOut();

                  // 로그인 페이지로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              /// 버킷 리스트
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                    future: fishingService.read(user.email!),
                    builder: (context, snapshot) {
                      print(snapshot.hasData);
                      final documents = snapshot.data?.docs ?? []; // 문서들 가져오기
                      if (documents.isEmpty) {
                        return Center(child: Text("낚시 기록이 없습니다."));
                      }
                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final doc = documents[index];
                          //DateTime date = DateTime.fromMicrosecondsSinceEpoch(doc.get('date'));
                          //String datetime = date.year.toString() + "/" + date.month.toString() + "/" + date.day.toString();
                          String timeString = doc.get('duration');
                          return ListTile(
                            title: Text(
                              timeString,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),);
                          /*return Row(
                            children: [
                              Text(
                              datetime,
                              style: TextStyle(
                                fontSize: 24,
                                color:  Colors.black,
                              ),
                            ),
                            Text(
                              timeString,
                              style: TextStyle(
                                fontSize: 24,
                                color:  Colors.black,
                              ),
                            ),
                            ]
                            
                          );*/
                        },
                      );
                    }),
              ),
              ElevatedButton(
                onPressed: () 
              {Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StopwatchApp()),
                            );}, 
                            child: Text("낚시 하기"))
            ],
          ),
        );
      },
    );
  }
}