import 'package:awa/screens/DoctorDetailScreen/components/doctordetailsscreen_body.dart';
import 'package:flutter/material.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final String doctorName;
  final int doctorAge;
  final int yearsOfExperience;
  final String description;

  const DoctorDetailsScreen({
    super.key,
    required this.doctorName,
    required this.doctorAge,
    required this.yearsOfExperience,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return DoctorDetailScreen(
      doctorName: doctorName,
      doctorAge: doctorAge,
      yearsOfExperience: yearsOfExperience,
      description: description,
    );
  }
}
