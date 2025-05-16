import 'package:flutter/material.dart';
import 'pages/consulta_cep_page.dart';

void main() {
  runApp(const ConsultaCepApp());
}

class ConsultaCepApp extends StatelessWidget {
  const ConsultaCepApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta CEP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConsultaCepPage(),
    );
  }
}