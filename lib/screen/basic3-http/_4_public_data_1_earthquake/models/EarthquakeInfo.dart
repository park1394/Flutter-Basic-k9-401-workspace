class EarthquakeInfo {
  final String originTime;  // 발생 시각
  final double magnitude;   // 규모
  final String location;    // 도로 명 (위치)
  final double depth;       // 진원 깊이 (km)

  EarthquakeInfo({
    required this.originTime,
    required this.magnitude,
    required this.location,
    required this.depth,
  });

  // JSON -> 객체 변환 (factory 생성자)
  factory EarthquakeInfo.fromJson(Map<String, dynamic> json) {
    return EarthquakeInfo(
      originTime: json['originTime']?.toString() ?? '',
      magnitude: double.tryParse(json['magnitude']?.toString() ?? '0') ?? 0.0,
      location: json['location']?.toString() ?? '',
      depth: double.tryParse(json['depth']?.toString() ?? '0') ?? 0.0,
    );
  }
}