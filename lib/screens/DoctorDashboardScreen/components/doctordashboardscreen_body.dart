import 'package:awa/screens/GenerateMeetlinksScreen/components/generate_meet_link_screen_body.dart';
import 'package:flutter/material.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  List<Map<String, String>> clientDemands = [
    {
      'clientName': 'Alice Johnson',
      'paymentType': 'Full Payment',
      'shortDescription': 'Ongoing anxiety and work-related stress...',
      'fullDescription':
          'Alice has been experiencing anxiety and stress due to her job. She also mentioned trouble sleeping for the past 3 weeks. Looking for therapy sessions focused on anxiety management.'
    },
    {
      'clientName': 'Michael Smith',
      'paymentType': 'Meet Payment',
      'shortDescription': 'Symptoms of depression, low energy...',
      'fullDescription':
          'Michael is feeling low energy and lack of motivation. He wants to start with one meeting to evaluate therapy possibilities.'
    },
    {
      'clientName': 'Sophie Lee',
      'paymentType': 'Full Payment',
      'shortDescription': 'Post-trauma recovery issues...',
      'fullDescription':
          'Sophie recently went through a traumatic event. She has frequent emotional breakdowns and is seeking regular therapy sessions.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF3E8B74),
        title: const Text(
          'Doctor Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: clientDemands.length,
        itemBuilder: (context, index) {
          final client = clientDemands[index];
          return GestureDetector(
            onTap: () => _showClientSheet(context, client, index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE0F2F1), Color(0xFFD0ECE7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client['clientName']!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    client['paymentType']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    client['shortDescription']!,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Tap to see more',
                      style: TextStyle(
                        color: Color(0xFF388E3C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showClientSheet(BuildContext context, Map<String, String> client, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                client['clientName']!,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Payment: ${client['paymentType']}',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Text(
                client['fullDescription']!,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text('Accept', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF43A047),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AcceptClientScreen(client: client),
                        ),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text('Reject', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDialog(
                        context,
                        title: 'Reject Request',
                        content: 'Are you sure you want to reject this request?',
                        onConfirm: () {
                          setState(() {
                            clientDemands.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Request Rejected')),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _confirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}

class AcceptClientScreen extends StatelessWidget {
  final Map<String, String> client;

  const AcceptClientScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Session"), backgroundColor: const Color(0xFF3E8B74)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: const Color(0xFFD0ECE7),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Client: ${client['clientName']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text("Payment Type: ${client['paymentType']}", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text(client['fullDescription'] ?? '', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Select Time of Day", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: ["Morning", "Afternoon", "Evening"].map((time) => ChoiceChip(label: Text(time), selected: false)).toList(),
            ),
            const SizedBox(height: 20),
            const Text("Select 2-Hour Slot", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: [
                "08:00 - 10:00",
                "10:00 - 12:00",
                "14:00 - 16:00",
                "16:00 - 18:00"
              ].map((slot) => ChoiceChip(label: Text(slot), selected: false)).toList(),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenerateMeetLinkScreen(client: client, clientData: {}),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Validate Demand", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
