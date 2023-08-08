import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class index extends StatelessWidget {
  const index({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Event-app'),),
        body: Center(
          child: Text('Ola Mundo'),
        ),
      ),
    );
  }
}