class DoctorModel {
  final String id;
  final String fullName;
  final String email;
  final String uniName;
  final String role;
  final String specialization;
  final String address;
  final String yearsOfExperience;  // Changed to String
  final String licenseNumber;
  final String password;

  DoctorModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.uniName,
    required this.role,
    required this.specialization,
    required this.address,
    required this.yearsOfExperience,  // Changed to String
    required this.licenseNumber,
    required this.password,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> data, String documentId) {
    return DoctorModel(
      id: documentId,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      uniName: data['uniName'] ?? '',
      role: data['role'] ?? '',
      specialization: data['specialization'] ?? '',
      address: data['address'] ?? '',
      yearsOfExperience: data['yearsOfExperience'] ?? '',  // Changed to String
      licenseNumber: data['licenseNumber'] ?? '',
      password: data['password'] ?? '',
    );
  }
}