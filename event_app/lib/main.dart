// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  
  //*Inicio do metodo responsavel por printar o modal
  void _openModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Novo Evento',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome do Evento'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição do Evento'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Lógica para salvar o evento
                  Navigator.pop(context); // Fechar o modal
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  //*Inicio do modal responsavel por editar os dados
  // ignore: unused_element
  void _openEditModal(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modal Title'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8, //? Definindo a largura
            height: MediaQuery.of(context).size.height * 0.2, //? Definindo a altura
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Nome do Evento'),
                ),
                Container(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Descrição do Evento'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
            TextButton(
              onPressed: () {
                // Process and save data
                Navigator.of(context).pop();
              },
              child: Text('Adicionar'),
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
                              _openEditModal(context);

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
                              
                              //!Inicio do link de redirecionamento

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
            
            //!Inicio do metodo responsavel por abrir o modal
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
