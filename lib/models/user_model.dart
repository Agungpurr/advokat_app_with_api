class User {
  final String id;
  final String username;
  final String email;
  final String? password;
  final String role;
  final String nama;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.password,
    required this.role,
    required this.nama,
    this.createdAt,
  });

  // Factory constructor dengan null safety dan type handling
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      print('🔄 Parsing user: ${json['username']}');

      return User(
        // 🔧 FIX: Handle both int and String for ID
        id: _parseId(json['id']),
        username: json['username']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        password: json['password']?.toString(),
        role: json['role']?.toString() ?? 'user',
        nama: json['nama']?.toString() ?? '',
        createdAt: json['createdAt'] != null
            ? _parseDateTime(json['createdAt'])
            : null,
      );
    } catch (e, stackTrace) {
      print('❌ Error in User.fromJson: $e');
      print('   JSON: $json');
      print('   Stack: $stackTrace');
      rethrow;
    }
  }

  // Helper method to parse ID (handle int or String)
  static String _parseId(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is int) return value.toString();
    return value.toString();
  }

  // Helper method to parse DateTime
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    try {
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      if (value is int) {
        // Timestamp in milliseconds
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
    } catch (e) {
      print('⚠️ Error parsing DateTime: $e, value: $value');
    }

    return null;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      if (password != null) 'password': password,
      'role': role,
      'nama': nama,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  // Helper methods
  bool isAdmin() => role.toLowerCase() == 'admin';
  bool isUser() => role.toLowerCase() == 'user';

  // Copy with method (untuk update user)
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? role,
    String? nama,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      nama: nama ?? this.nama,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, nama: $nama, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
