// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:event_app/screens/addEvent.dart';
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
              //?Inicio das cards do meu aplicativo
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
                              // Lógica de edição
                            },
                          ),
                        ),
                        //*Inicio do butao responsavel por eliminar
                        Align(
                          alignment: Alignment.topRight, // Alinhar o ícone à esquerda
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              // Lógica de exclusão
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
            
            //!Inicio do link de redirecionamenot
            Navigator.of(context).pop();
            addEvent();

          },
          child: Icon(Icons.add),
          backgroundColor: Colors.yellow,
        ),
      ),
    );
  }
}