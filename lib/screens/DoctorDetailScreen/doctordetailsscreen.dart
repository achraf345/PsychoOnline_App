import 'package:awa/screens/DoctorDetailScreen/components/doctordetailsscreen_body.dart';
import 'package:flutter/material.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final String doctorEmail; // ✅ Changed to doctorEmail
  final String doctorName;
  final int doctorAge;
  final int yearsOfExperience;
  final String description;

  const DoctorDetailsScreen({
    super.key,
    required this.doctorEmail, // ✅ Changed to doctorEmail
    required this.doctorName,
    required this.doctorAge,
    required this.yearsOfExperience,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return DoctorDetailScreen(
      doctorEmail: doctorEmail, // ✅ Pass doctorEmail to body
      doctorName: doctorName,
      doctorAge: doctorAge,
      yearsOfExperience: yearsOfExperience,
      description: description,
    );
  }
}
