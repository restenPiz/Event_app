// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
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
          //*Inicio da coluna que e responsavel por colocar todas as cards
          child: Column(
            children: [
              Card(
                elevation: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    ListTile(
                      title: Text('Mauro Peniel'),
                      subtitle: Text('Eu sou mauro peniel'),
                    ),
                    ButtonBar(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                            
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                            
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Card(
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
            ],
          ),
        ),
      ),
    );
  }
}