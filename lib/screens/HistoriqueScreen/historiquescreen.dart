
import 'package:flutter/material.dart';
import 'components/historiquescreen_body.dart';

class HistoriqueScreen extends StatelessWidget {
  const HistoriqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        backgroundColor: const Color(0xFF5A8DEE),
        centerTitle: true,
      ),
      body: const HistoriqueScreenBody(),
    );
  }
}

    