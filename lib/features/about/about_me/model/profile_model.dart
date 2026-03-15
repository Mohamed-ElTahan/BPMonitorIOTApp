class ProfileModel {
  final String name;
  final String bio;
  final String role;
  final String githubUrl;
  final String email;
  final String linkedInUrl;
  final String whatsappNumber;

  ProfileModel({
    required this.name,
    required this.bio,
    required this.role,
    required this.githubUrl,
    required this.email,
    required this.linkedInUrl,
    required this.whatsappNumber,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      role: json['role'] as String? ?? '',
      githubUrl: json['githubUrl'] as String? ?? '',
      email: json['email'] as String? ?? '',
      linkedInUrl: json['linkedInUrl'] as String? ?? '',
      whatsappNumber: json['whatsappNumber'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'role': role,
      'githubUrl': githubUrl,
      'email': email,
      'linkedInUrl': linkedInUrl,
      'whatsappNumber': whatsappNumber,
    };
  }
}
