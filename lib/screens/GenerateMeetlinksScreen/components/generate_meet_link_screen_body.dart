import 'package:flutter/material.dart';

class GenerateMeetLinkScreen extends StatelessWidget {
  final Map<String, String> client;

  const GenerateMeetLinkScreen({super.key, required this.client, required Map clientData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate Meet Link"),
        backgroundColor: const Color(0xFF3E8B74),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.video_call, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text("Generating link for ${client['clientName']}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Meet link generated and shared!")),
                );
              },
              icon: const Icon(Icons.link),
              label: const Text("Generate Google Meet Link"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
