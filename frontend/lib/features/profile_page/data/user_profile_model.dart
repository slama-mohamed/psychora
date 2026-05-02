class UserProfileModel {
  final String fullName;
  final String profession;
  final bool isAvailable;
  final String email;
  final String phone;
  final String location;
  final String specialization;
  final String hospital;
  final String bio;
  final String idCard;
  final int yearsOfExperience;
  final int patientsCount;
  final int sessionsCount;
  final double rating;

  const UserProfileModel({
    required this.fullName,
    required this.profession,
    required this.isAvailable,
    required this.email,
    required this.phone,
    required this.location,
    required this.specialization,
    required this.hospital,
    required this.bio,
    required this.idCard,
    required this.yearsOfExperience,
    required this.patientsCount,
    required this.sessionsCount,
    required this.rating,
  });

  factory UserProfileModel.fromApi(Map<String, dynamic> data) {
    final String fullName = _readString(data, <String>[
      'fullName',
      'name',
      'username',
      'doctorName',
    ]);

    return UserProfileModel(
      fullName: fullName.isNotEmpty ? fullName : 'Utilisateur',
      profession: _readString(data, <String>[
        'profession',
        'role',
        'jobTitle',
        'title',
      ], fallback: 'Psychologue'),
      isAvailable: _readBool(data, <String>[
        'isAvailable',
        'available',
        'online',
      ], fallback: true),
      email: _readString(data, <String>[
        'email',
        'mail',
      ], fallback: 'N/A'),
      phone: _readString(data, <String>[
        'phone',
        'phoneNumber',
        'mobile',
      ], fallback: 'N/A'),
      location: _readString(data, <String>[
        'location',
        'city',
        'address',
      ], fallback: 'N/A'),
      specialization: _readString(data, <String>[
        'specialization',
        'specialty',
        'domain',
      ], fallback: 'N/A'),
      hospital: _readString(data, <String>[
        'hospital',
        'clinic',
        'workplace',
      ], fallback: ''),
      bio: _readString(data, <String>[
        'bio',
        'about',
        'description',
      ], fallback: ''),
      idCard: _readString(data, <String>[
        'idCard',
        'idNumber',
        'cin',
      ], fallback: ''),
      yearsOfExperience: _readInt(data, <String>[
        'yearsOfExperience',
        'experienceYears',
        'experience',
      ], fallback: 0),
      patientsCount: _readInt(data, <String>[
        'patientsCount',
        'totalPatients',
        'patients',
      ], fallback: 0),
      sessionsCount: _readInt(data, <String>[
        'sessionsCount',
        'totalSessions',
        'sessions',
      ], fallback: 0),
      rating: _readDouble(data, <String>[
        'rating',
        'averageRating',
      ], fallback: 0),
    );
  }

  String get initials {
    final List<String> parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  static String _readString(
    Map<String, dynamic> data,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final String key in keys) {
      final dynamic value = data[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return fallback;
  }

  static bool _readBool(
    Map<String, dynamic> data,
    List<String> keys, {
    required bool fallback,
  }) {
    for (final String key in keys) {
      final dynamic value = data[key];
      if (value is bool) {
        return value;
      }
      if (value is String) {
        final normalized = value.trim().toLowerCase();
        if (normalized == 'true' || normalized == '1') {
          return true;
        }
        if (normalized == 'false' || normalized == '0') {
          return false;
        }
      }
      if (value is num) {
        return value != 0;
      }
    }
    return fallback;
  }

  static int _readInt(
    Map<String, dynamic> data,
    List<String> keys, {
    required int fallback,
  }) {
    for (final String key in keys) {
      final dynamic value = data[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value is String) {
        final int? parsed = int.tryParse(value.trim());
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return fallback;
  }

  static double _readDouble(
    Map<String, dynamic> data,
    List<String> keys, {
    required double fallback,
  }) {
    for (final String key in keys) {
      final dynamic value = data[key];
      if (value is double) {
        return value;
      }
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        final double? parsed = double.tryParse(value.trim());
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return fallback;
  }
}
