import 'package:fishing/home_page.dart';
import 'package:fishing/stopwatch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'bluetooth_search.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser();
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text('강태공', style: TextStyle(fontSize: 28)),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 10, 60, 101),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(60.0),
                    child: Text("\u{1f3a3}",
                        style: TextStyle(
                          fontSize: 110,
                        )),
                  ),
                  // 이메일
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(hintText: 'Email'),
                    ),
                  ),
                  // 비밀번호
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true, // 비밀번호 안 보이게
                      decoration: InputDecoration(hintText: 'PASSWORD'),
                    ),
                  ),
                  // 로그인 버튼
                  Container(
                    width: 200,
                    margin: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        // 로그인
                        authService.signIn(
                          email: emailController.text,
                          password: passwordController.text,
                          onSuccess: () {
                            // 로그인 성공
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("로그인 성공"),
                            ));

                            // HomePage로 이동
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                          onError: (err) {
                            // 에러 발생
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(err),
                            ));
                          },
                        );
                      },
                      child: Text('Log in'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 10, 60, 101))),
                    ),
                  ),
                  // 회원가입 버튼
                  Container(
                    width: 200,
                    margin: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        // 회원가입
                        authService.signUp(
                          email: emailController.text,
                          password: passwordController.text,
                          onSuccess: () {
                            // 회원가입 성공
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("회원가입 성공"),
                            ));
                          },
                          onError: (err) {
                            // 에러 발생
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(err),
                            ));
                          },
                        );
                      },
                      child: Text('회원가입'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 17, 91, 152))),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}