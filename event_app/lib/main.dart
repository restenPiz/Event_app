import 'package:event_app/screens/index.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    //?Referenciando a minha widget do index que contem todo o conteudo
    // ignore: prefer_const_constructors
    return index();
  }
}
