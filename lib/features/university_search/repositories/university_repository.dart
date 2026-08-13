import '../../../services/supabase_service.dart';
import '../models/university_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UniversityRepository {
  // Use mock for development if DB is unseeded
  static const bool _useMockData = true;
  static const int _pageSize = 10;

  Future<List<UniversityModel>> fetchUniversities({
    String query = '',
    String? major,
    String? location,
    double? budgetMax,
    double? minGradeMax,
    bool scholarshipRequired = false,
    int page = 0,
  }) async {
    if (_useMockData) {
      // Return hardcoded mock data for now
      return Future.delayed(
        const Duration(milliseconds: 600),
        () => _getMockData(query),
      );
    }

    try {
      SupabaseQueryBuilder queryBuilder = SupabaseService.client.from(
        'universities',
      );
      PostgrestFilterBuilder<List<Map<String, dynamic>>> filterBuilder =
          queryBuilder.select();

      if (query.isNotEmpty) {
        filterBuilder = filterBuilder.ilike('name', '%$query%');
      }

      if (location != null && location.isNotEmpty) {
        filterBuilder = filterBuilder.eq('governorate', location);
      }
      if (budgetMax != null) {
        filterBuilder = filterBuilder.lte('tuition_per_year', budgetMax);
      }
      if (minGradeMax != null) {
        filterBuilder = filterBuilder.lte('min_grade', minGradeMax);
      }
      if (scholarshipRequired) {
        filterBuilder = filterBuilder.gt('scholarship_max_percent', 0);
      }

      final response = await filterBuilder.range(
        page * _pageSize,
        (page + 1) * _pageSize - 1,
      );

      return (response as List)
          .map((json) => UniversityModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch universities: $e');
    }
  }

  List<UniversityModel> _getMockData(String query) {
    var mocks = [
      UniversityModel(
        id: '1',
        name: 'Cairo University',
        nameAr: 'جامعة القاهرة',
        city: 'Giza',
        cityAr: 'الجيزة',
        governorate: 'Giza',
        tuitionPerYear: 15000,
        minGrade: 85,
        universityType: 'public',
        applicationDeadline: null,
        scholarshipMaxPercent: 0,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA5UOPc2BFekJBhdvFPNV1WzQT4UtSBGcwMRyZdHEhTKJNOyDhR2RU3cMKtLRC_KzMnnghTuQYrAoj-SkUASdGub442Wm3x8ah1YBDW2bmsqSX1RzoKOyX3KcsXrUZ-h74O1GKnEE4mSta0hLpP0dxkkQhhSiGMSZjrTWU24lIoOfwvzeTI5eFaCQRCTfyVIsaVA8fPrqmDQLZIILubLQkahSOVVJGc79ltfY1y-uzuRxVUwyhVHhI',
        dataSource: 'mock',
        lastVerifiedAt: null,
        latitude: 0,
        longitude: 0,
        fitScore: 85,
      ),
      UniversityModel(
        id: '2',
        name: 'Ain Shams University',
        nameAr: 'جامعة عين شمس',
        city: 'Cairo',
        cityAr: 'القاهرة',
        governorate: 'Cairo',
        tuitionPerYear: 16000,
        minGrade: 84,
        universityType: 'public',
        applicationDeadline: null,
        scholarshipMaxPercent: 0,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB2nqr4OkD0alXtM6DaPQx2JT-SveEOuIZrInJOz3hqBjFunAtlcCsWINNBKOKHyDMDupyFdersGpu5C2o3a8DW-S34hgKHC1FrR4QUrRET8_sd2yXGnLFWaIvl7Ion7PMadAIG6ZZuq6EYY5VgkmWqaYQLHOvTozYGNWn9kTaGbu6Ysu7RLQGI_dhkR92SXGVEfY6s3eecEmGQfDnyw-tZAbQ054s8yQjKMbky1ATfSnUqZfkDRNk',
        dataSource: 'mock',
        lastVerifiedAt: null,
        latitude: 0,
        longitude: 0,
        fitScore: 65,
      ),
      UniversityModel(
        id: '3',
        name: 'Zewail City of Science',
        nameAr: 'مدينة زويل للعلوم والتكنولوجيا',
        city: 'Giza',
        cityAr: 'الجيزة',
        governorate: 'Giza',
        tuitionPerYear: 120000,
        minGrade: 90,
        universityType: 'national',
        applicationDeadline: null,
        scholarshipMaxPercent: 100,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuC6DukWK5mTgX9ltk6AIjN3-XuPLZaFcYdd2IWoV2XkOA9a0qdVsOddgQpICMgdNz8RrROL9jj31jS_MpA00Z4bwDW3V0yCCIMDhxEM_I76mCZOfCntFD5XykTARDJms_waCkAxI-C5wgBMr6puvEyeuZ1_zXqhDgHRXstbSSlceYN3wi26r-ymnqhWfUuBY1wq1inYnQOs02ZrF70HGOtS3z6Z_hUIAvlOkWVKuJT6lsuwtV8FHac',
        dataSource: 'mock',
        lastVerifiedAt: null,
        latitude: 0,
        longitude: 0,
        fitScore: 92,
      ),
    ];

    if (query.isNotEmpty) {
      return mocks
          .where((u) => u.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return mocks;
  }
}
