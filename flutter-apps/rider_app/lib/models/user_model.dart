class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String userType; // 'rider', 'driver', 'admin'
  final String phoneNumber;
  final String profilePictureUrl;
  final String? token;
  final Map<String, dynamic>? metadata;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.phoneNumber,
    required this.profilePictureUrl,
    this.token,
    this.metadata,
  });

  // Get full name
  String get fullName => '$firstName $lastName';

  // Check if user is a driver
  bool get isDriver => userType == 'driver';

  // Check if user is a rider
  bool get isRider => userType == 'rider';

  // Check if user is an admin
  bool get isAdmin => userType == 'admin';

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'userType': userType,
        'phoneNumber': phoneNumber,
        'profilePictureUrl': profilePictureUrl,
        'token': token,
        'metadata': metadata,
      };

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        email: json['email'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        userType: json['userType'] ?? 'rider',
        phoneNumber: json['phoneNumber'] ?? '',
        profilePictureUrl: json['profilePictureUrl'] ?? '',
        token: json['token'],
        metadata: json['metadata'],
      );

  // Copy with new values
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? userType,
    String? phoneNumber,
    String? profilePictureUrl,
    String? token,
    Map<String, dynamic>? metadata,
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        userType: userType ?? this.userType,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
        token: token ?? this.token,
        metadata: metadata ?? this.metadata,
      );
}