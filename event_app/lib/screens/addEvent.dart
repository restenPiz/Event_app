// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class addEvent extends StatelessWidget {
  const addEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Event-app'),
        ),
        body: Center(
          child: Text('Ola Mundo'),
        ),
      ),
    );
  }
}