import 'package:awa/screens/CloginScreen/clogin_screen.dart';
import 'package:awa/screens/DoctorDetailScreen/doctordetailsscreen.dart';
import 'package:awa/screens/HistoriqueScreen/components/historiquescreen_body.dart';
import 'package:awa/screens/PaymentClientScreen/components/paymentclientscreen_body.dart';
import 'package:awa/screens/TermsScreen/components/termsscreen_body.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class Doctor {
  final String email;
  final String name;
  final String description;
  final int experience;
  final int age;

  const Doctor({
    required this.email,
    required this.name,
    required this.description,
    required this.experience,
    required this.age,
  });

  factory Doctor.fromFirestore(Map<String, dynamic> data) {
    return Doctor(
      email: data['email'] ?? '',
      name: data['fullName'] ?? '',
      description: data['description'] ?? '',
      experience: int.tryParse(data['experience'].toString()) ?? 0,
      age: int.tryParse(data['age']?.toString() ?? '') ?? 0,
    );
  }
}

class CdashbordscreenBody extends StatelessWidget {
  const CdashbordscreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF64B5F6), Color(0xFFBBDEFB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => CLoginScreen()),
                        );
                      },
                    ),
                    Text(
                      'Meet Your Specialist',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Something went wrong', style: TextStyle(color: Colors.white)),
                      );
                    }
                    final docs = snapshot.data!.docs;
                    if (docs.isEmpty) {
                      return const Center(
                        child: Text('No doctors available', style: TextStyle(color: Colors.white)),
                      );
                    }

                    final doctors = docs.map((d) {
                      final data = d.data() as Map<String, dynamic>;
                      return Doctor.fromFirestore(data);
                    }).toList()
                      ..sort((a, b) => b.experience.compareTo(a.experience));

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: doctors.length,
                      itemBuilder: (context, i) {
                        final doc = doctors[i];
                        final brief = doc.description.length > 100
                            ? '${doc.description.substring(0, 100)}…'
                            : doc.description;

                        return InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DoctorDetailsScreen(
                                  doctorEmail: doc.email,
                                  doctorName: doc.name,
                                  doctorAge: doc.age,
                                  yearsOfExperience: doc.experience,
                                  description: doc.description,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 8,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dr. ${doc.name}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF444C74),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${doc.experience} years of experience',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Email: ${doc.email}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    brief,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(4),
                                      onTap: () => showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          title: Text(
                                            'Dr. ${doc.name}',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Email: ${doc.email}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  doc.description,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: Text(
                                                'Close',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Text(
                                          'See more',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.8),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Dashboard',
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreenBody()));
                      },
                      child: Text(
                        'Terms',
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoriqueScreenBody()));
                      },
                      child: Text(
                        'Historique',
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentClientScreenBody()));
                      },
                      child: Text(
                        'Payment',
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
