// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

// ignore: camel_case_types
class index extends StatelessWidget {
  const index({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Event-app'),),
        body: Center(
          child: Card(
            elevation: 4,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ListTile(
                  title: Text('Mauro Peniel'),
                  subtitle: Text('Eu sou mauro peniel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}