class PlantSpecies {
  String id;
  String commonName;
  List<String> scientificName;
  List<String> otherName;
  String cycle;
  String watering;
  List<String> sunlight;
  PlantImages defaultImage;

  PlantSpecies({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.otherName,
    required this.cycle,
    required this.watering,
    required this.sunlight,
    required this.defaultImage,
  });

  factory PlantSpecies.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data is null");
    }
    return PlantSpecies(
      id: json['id']?.toString() ?? '',
      commonName: json['common_name'] ?? '',
      scientificName: json['scientific_name'] == null ? [] : List<String>.from(json['scientific_name']),
      otherName: json['other_name'] == null ? [] : List<String>.from(json['other_name']),
      cycle: json['cycle'] ?? '',
      watering: json['watering'] ?? '',
      sunlight: json['sunlight'] == null ? [] : List<String>.from(json['sunlight']),
      defaultImage: json['default_image'] == null ? PlantImages.empty() : PlantImages.fromJson(json['default_image']),
    );
  }

}

class PlantImages {
  int license;
  String licenseName;
  String licenseUrl;
  String originalUrl;
  String regularUrl;
  String mediumUrl;
  String smallUrl;
  String thumbnail;

  PlantImages({
    required this.license,
    required this.licenseName,
    required this.licenseUrl,
    required this.originalUrl,
    required this.regularUrl,
    required this.mediumUrl,
    required this.smallUrl,
    required this.thumbnail,
  });

  factory PlantImages.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return PlantImages.empty();
    }
    return PlantImages(
      license: json['license'] ?? 0,
      licenseName: json['license_name'] ?? '',
      licenseUrl: json['license_url'] ?? '',
      originalUrl: json['original_url'] ?? '',
      regularUrl: json['regular_url'] ?? '',
      mediumUrl: json['medium_url'] ?? '',
      smallUrl: json['small_url'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  factory PlantImages.empty() {
    return PlantImages(
      license: 0,
      licenseName: '',
      licenseUrl: '',
      originalUrl: '',
      regularUrl: '',
      mediumUrl: '',
      smallUrl: '',
      thumbnail: '',
    );
  }
}

class ApiResponse {
  int currentPage;
  int perPage;
  List<PlantSpecies> data;

  ApiResponse({
    required this.currentPage,
    required this.perPage,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data is null");
    }
    return ApiResponse(
      currentPage: _parseInt(json['currentPage']),
      perPage: _parseInt(json['perPage']),
      data: json['data'] == null ? [] : (json['data'] as List).map((e) => PlantSpecies.fromJson(e as Map<String, dynamic>?)).toList(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? 0;
    } else {
      return 0; // Default value or throw an error
    }
  }
}

