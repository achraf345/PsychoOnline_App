import 'package:awa/screens/DoctorDetailScreen/components/doctordetailsscreen_body.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Doctor {
  final String name;
  final String description;
  final int experience;

  const Doctor({
    required this.name,
    required this.description,
    required this.experience,
  });
}

class CdashbordscreenBody extends StatelessWidget {
  final List<Doctor> doctors = const [
    Doctor(
      name: "Dr. John Doe",
      description:
          "Experienced in general medicine, specializing in family care and preventive treatment.",
      experience: 10,
    ),
    Doctor(
      name: "Dr. Jane Smith",
      description:
          "Specialist in cardiology with years of experience in heart-related treatments.",
      experience: 15,
    ),
    Doctor(
      name: "Dr. Emma Brown",
      description:
          "An expert in pediatric care, passionate about children’s health and wellness.",
      experience: 7,
    ),
    Doctor(
      name: "Dr. James White",
      description:
          "A renowned orthopedic surgeon known for advanced surgery and joint care.",
      experience: 12,
    ),
  ];

  const CdashbordscreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final sortedDoctors = List<Doctor>.from(doctors)
      ..sort((a, b) => b.experience.compareTo(a.experience));

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5C6BC0), Color(0xFFB39DDB)], // soft blue and purple
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Meet Your Specialist',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: sortedDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = sortedDoctors[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DoctorDetailScreen(
                            doctorName: doctor.name,
                            doctorAge: 45,
                            yearsOfExperience: doctor.experience,
                            description: doctor.description,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            colors: [Colors.white, Color(0xFFEDE7F6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.name,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3F51B5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${doctor.experience} years of experience',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              doctor.description.length > 70
                                  ? '${doctor.description.substring(0, 70)}...'
                                  : doctor.description,
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade800,
                                fontSize: 14,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(doctor.name),
                                      content: Text(doctor.description),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text(
                                  'See more',
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Cdashbordscreen extends StatelessWidget {
  const Cdashbordscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CdashbordscreenBody(),
    );
  }
}
