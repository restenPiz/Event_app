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
        appBar: AppBar(
          title: Text('Event-app'),
          backgroundColor: Colors.amberAccent,
          ),
        body: Center(
          child: Card(
            elevation: 4,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              // ignore: prefer_const_literals_to_create_immutables
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