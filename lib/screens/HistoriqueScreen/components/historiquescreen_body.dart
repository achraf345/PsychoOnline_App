import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoriqueScreenBody extends StatelessWidget {
  const HistoriqueScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final clientEmail = FirebaseAuth.instance.currentUser?.email;

    if (clientEmail == null) {
      return const Center(child: Text('No user logged in.'));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Historique',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 8,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF80C7B5), // Mint green
              Color(0xFF70C5E7), // Light sky blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('demands')
              .where('clientEmail', isEqualTo: clientEmail)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data.', style: TextStyle(color: Colors.white)));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No demands found.', style: TextStyle(color: Colors.white)));
            }

            final demands = snapshot.data!.docs;

            return ListView.builder(
              itemCount: demands.length,
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 24),
              itemBuilder: (context, index) {
                final demand = demands[index].data() as Map<String, dynamic>;
                final meetingDate = demand['meetingDate'].toDate();
                final formattedDate = DateFormat('MMMM dd, yyyy').format(meetingDate);

                return GestureDetector(
                  onTap: () => _showDemandDetails(context, demand, index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white, // Clean white for the card
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. ${demand['doctorName']}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF357B83), // Cool teal blue
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Color(0xFF357B83), size: 20),
                              const SizedBox(width: 8),
                              Text(
                                formattedDate,
                                style: const TextStyle(fontSize: 16, color: Color(0xFF357B83)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.psychology, color: Color(0xFF357B83), size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  demand['problemDescription'],
                                  style: const TextStyle(fontSize: 16, color: Color(0xFF357B83)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.payment, color: Color(0xFF357B83), size: 20),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                                decoration: BoxDecoration(
                                  color: demand['paymentType'] == 'Full Payment'
                                      ? const Color.fromARGB(255, 71, 132, 255) 
                                      : const Color.fromARGB(255, 0, 118, 253), 
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  demand['paymentType'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showDemandDetails(BuildContext context, Map<String, dynamic> demand, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Demand Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF357B83))),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Doctor: Dr. ${demand['doctorName']}', style: const TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10),
                Text('Problem Description: ${demand['problemDescription']}', style: const TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10),
                Text('Meeting Date: ${DateFormat('MMMM dd, yyyy').format(demand['meetingDate'].toDate())}', style: const TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10),
                Text('Payment Type: ${demand['paymentType']}', style: const TextStyle(fontSize: 16, color: Colors.black)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Color(0xFF357B83))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Demand has been marked as deleted from UI')),
                );
              },
              child: const Text('Delete', style: TextStyle(fontSize: 16, color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
