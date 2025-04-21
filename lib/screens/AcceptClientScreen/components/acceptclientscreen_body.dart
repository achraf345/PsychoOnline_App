import 'package:awa/screens/GenerateMeetlinksScreen/components/generate_meet_link_screen_body.dart';
import 'package:flutter/material.dart';

class AcceptClientScreen extends StatelessWidget {
  final Map<String, String> client;
  const AcceptClientScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Session"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client Info
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.deepPurple.shade50,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Client: ${client['clientName']}\n"
                  "Payment: ${client['paymentType']}\n"
                  "${client['fullDescription']}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Validate Demand Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  // Navigate directly to GenerateMeetLinkScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GenerateMeetLinkScreen(
                        clientData: client, client: {},
                      ),
                    ),
                  );
                },
                child: const Text("Validate Demand"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
