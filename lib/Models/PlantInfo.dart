class PlantInfo {
  String description;
  String ecology;
  String introduction;
  String treeName;
  String uses;

  PlantInfo({
    required this.description,
    required this.ecology,
    required this.introduction,
    required this.treeName,
    required this.uses,
  });

  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    return PlantInfo(
      description: json['description'] ?? '',
      ecology: json['ecology'] ?? '',
      introduction: json['introduction'] ?? '',
      treeName: json['tree_name'] ?? '',
      uses: json['uses'] ?? '',
    );
  }
}
