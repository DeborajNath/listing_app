class User {
  final String firstName;
  final String lastName;
  final String city;
  final String phoneNumber;
  final String profilePictureUrl;

  User({
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.phoneNumber,
    required this.profilePictureUrl,
  });

  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      firstName: data['First Name'] ?? '',
      lastName: data['Last Name'] ?? '',
      city: data['City'] ?? '',
      phoneNumber: data['Phone Number'] ?? '',
      profilePictureUrl: data['Profile Picture URL'] ?? '',
    );
  }
}
