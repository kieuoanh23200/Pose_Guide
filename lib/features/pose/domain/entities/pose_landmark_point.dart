import 'package:equatable/equatable.dart';

/// ============================================================================
/// POSE LANDMARK POINT — Điểm Khớp Khung Xương Chuẩn Hóa [0.0 - 1.0]
/// Đại diện cho 1 trong 33 điểm mốc giải phẫu học cơ thể (Google ML Kit / MediaPipe)
/// ============================================================================
class PoseLandmarkPoint extends Equatable {
  final int type; // 0..32 (Nose, Shoulders, Elbows, Wrists, Hips, Knees, Ankles...)
  final double x; // Tỉ lệ chuẩn hóa trục hoành [0.0 -> 1.0]
  final double y; // Tỉ lệ chuẩn hóa trục tung [0.0 -> 1.0]
  final double z; // Độ sâu tương đối 3D
  final double likelihood; // Độ tin cậy nhận diện của AI (0.0 -> 1.0)

  const PoseLandmarkPoint({
    required this.type,
    required this.x,
    required this.y,
    this.z = 0.0,
    this.likelihood = 1.0,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'x': x,
        'y': y,
        'z': z,
        'likelihood': likelihood,
      };

  factory PoseLandmarkPoint.fromJson(Map<String, dynamic> json) => PoseLandmarkPoint(
        type: json['type'] as int,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        z: (json['z'] as num?)?.toDouble() ?? 0.0,
        likelihood: (json['likelihood'] as num?)?.toDouble() ?? 1.0,
      );

  @override
  List<Object?> get props => [type, x, y, z, likelihood];
}
