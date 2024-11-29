import 'dart:async';

import 'package:flutter/material.dart';

import 'Todo.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class homepage extends StatefulWidget
{
  @override
  homepagestate createState()=> homepagestate();

}

class homepagestate extends State<homepage>
{
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds:5),() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Todo()));
    },
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/front.jpg"),
            fit: BoxFit.cover,
          )
        ),
      ),
    );
  }

}

