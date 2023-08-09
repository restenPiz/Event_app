// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  
  void _openModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modal Title'),
          content: Text('This is a modal content.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

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
              //*Inicio da card do aplicativo
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Borda arredondada
                ),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Margem
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    ListTile(
                      title: Text('Mauro Peniel'),
                      subtitle: Text('Eu sou mauro peniel'),
                    ),

                    //*Inicio do button Bar responsavel por Editar e Eliminar

                    ButtonBar(
                      alignment: MainAxisAlignment.end, // Alinhar à esquerda
                      children: [
                        //*Inicio do butao responsavel por editar
                        Align(
                          alignment: Alignment.centerLeft, // Alinhar o ícone à esquerda
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () {

                              //!Inicio do link de redirecionamento
                              Text('Ola Mundo');

                            },
                          ),
                        ),
                        //*Inicio do butao responsavel por eliminar
                        Align(
                          alignment: Alignment.topRight, // Alinhar o ícone à esquerda
                          child: IconButton(
                            icon: Icon(Icons.delete), //? Icone de eliminar
                            color: Colors.red,
                            onPressed: () {
                              
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //*Adicionando o butao responsavel por fazer criar o evento
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            
          _openModal(context);      

          },
          child: Icon(Icons.add),
          backgroundColor: Colors.yellow,
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Counter(),
        ),
      ),
    ),
  );
}
