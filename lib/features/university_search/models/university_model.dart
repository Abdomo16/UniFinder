class UniversityModel {
  const UniversityModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.city,
    required this.cityAr,
    required this.governorate,
    required this.tuitionPerYear,
    required this.minGrade,
    required this.universityType,
    required this.applicationDeadline,
    required this.scholarshipMaxPercent,
    required this.imageUrl,
    required this.dataSource,
    required this.lastVerifiedAt,
    required this.latitude,
    required this.longitude,
    this.fitScore,
  });

  final String id;
  final String name;
  final String nameAr;
  final String city;
  final String cityAr;
  final String governorate;
  final double tuitionPerYear;
  final double minGrade;
  final String universityType; // public / national / private
  final DateTime? applicationDeadline;
  final double scholarshipMaxPercent;
  final String imageUrl;
  final String dataSource;
  final DateTime? lastVerifiedAt;
  final double latitude;
  final double longitude;
  final int?
  fitScore; // For match badge (0-100), not persisted via to/fromJson directly

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      city: json['city'] as String? ?? '',
      cityAr: json['city_ar'] as String? ?? '',
      governorate: json['governorate'] as String? ?? '',
      tuitionPerYear: (json['tuition_per_year'] as num?)?.toDouble() ?? 0.0,
      minGrade: (json['min_grade'] as num?)?.toDouble() ?? 0.0,
      universityType: json['university_type'] as String? ?? '',
      applicationDeadline: json['application_deadline'] != null
          ? DateTime.tryParse(json['application_deadline'] as String)
          : null,
      scholarshipMaxPercent:
          (json['scholarship_max_percent'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String? ?? '',
      dataSource: json['data_source'] as String? ?? '',
      lastVerifiedAt: json['last_verified_at'] != null
          ? DateTime.tryParse(json['last_verified_at'] as String)
          : null,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'city': city,
      'city_ar': cityAr,
      'governorate': governorate,
      'tuition_per_year': tuitionPerYear,
      'min_grade': minGrade,
      'university_type': universityType,
      'application_deadline': applicationDeadline?.toIso8601String(),
      'scholarship_max_percent': scholarshipMaxPercent,
      'image_url': imageUrl,
      'data_source': dataSource,
      'last_verified_at': lastVerifiedAt?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  UniversityModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? city,
    String? cityAr,
    String? governorate,
    double? tuitionPerYear,
    double? minGrade,
    String? universityType,
    DateTime? applicationDeadline,
    double? scholarshipMaxPercent,
    String? imageUrl,
    String? dataSource,
    DateTime? lastVerifiedAt,
    double? latitude,
    double? longitude,
    int? fitScore,
  }) {
    return UniversityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      city: city ?? this.city,
      cityAr: cityAr ?? this.cityAr,
      governorate: governorate ?? this.governorate,
      tuitionPerYear: tuitionPerYear ?? this.tuitionPerYear,
      minGrade: minGrade ?? this.minGrade,
      universityType: universityType ?? this.universityType,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      scholarshipMaxPercent:
          scholarshipMaxPercent ?? this.scholarshipMaxPercent,
      imageUrl: imageUrl ?? this.imageUrl,
      dataSource: dataSource ?? this.dataSource,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      fitScore: fitScore ?? this.fitScore,
    );
  }
}
