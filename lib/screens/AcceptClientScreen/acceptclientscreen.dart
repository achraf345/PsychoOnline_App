import 'package:awa/screens/AcceptClientScreen/components/acceptclientscreen_body.dart';
import 'package:flutter/material.dart';

class AcceptClientScreen extends StatelessWidget {
  final Map<String, dynamic> clientData;
  final String docId;

  const AcceptClientScreen({
    super.key,
    required this.clientData,
    required this.docId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Accept Client',
          style: TextStyle(color: Colors.white), 
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32), 
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      body: AcceptClientScreenBody(
        clientData: clientData,
        docId: docId,
      ),
    );
  }
}
