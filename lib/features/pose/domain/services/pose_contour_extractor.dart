import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// ============================================================================
/// POSE CONTOUR EXTRACTOR — Bộ Trích Xuất Nét Vẽ Dáng Chụp (Line Art Silhouette)
/// 1. Xử lý offline on-device: Thu nhỏ ảnh, tính toán độ chênh lệch ánh sáng (Sobel Gradient),
///    lọc ngưỡng cấu trúc cơ thể, chuyển thành nét trắng trên nền trong suốt (Transparent PNG).
/// 2. Hỗ trợ mở rộng kết nối Cloud AI (ControlNet Lineart / HED / rembg) khi có endpoint.
/// ============================================================================
class PoseContourExtractor {
  PoseContourExtractor._();
  static final PoseContourExtractor instance = PoseContourExtractor._();

  /// Trích xuất nét viền từ file ảnh trên máy hoặc bộ nhớ
  Future<String> extractLineArtFromBytes(Uint8List imageBytes, {int targetWidth = 360}) async {
    // 1. Giải mã ảnh thành ui.Image với kích thước tối ưu (360px cho tốc độ nhanh & mượt)
    final codec = await ui.instantiateImageCodec(imageBytes, targetWidth: targetWidth);
    final frameInfo = await codec.getNextFrame();
    final sourceImage = frameInfo.image;

    final width = sourceImage.width;
    final height = sourceImage.height;

    final byteData = await sourceImage.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) {
      throw Exception('Không thể đọc dữ liệu điểm ảnh');
    }

    final rawPixels = byteData.buffer.asUint8List();

    // 2. Chuyển đổi sang ma trận độ sáng Grayscale
    final grayscale = Uint8List(width * height);
    for (int i = 0; i < rawPixels.length; i += 4) {
      final r = rawPixels[i];
      final g = rawPixels[i + 1];
      final b = rawPixels[i + 2];
      // Công thức Luminance chuẩn REC.601
      final lum = (r * 299 + g * 587 + b * 114) ~/ 1000;
      grayscale[i ~/ 4] = lum;
    }

    // 3. Áp dụng Sobel Filter trích xuất biên cạnh sắc nét (Contours & Silhouette)
    final outputRgba = Uint8List(width * height * 4);
    const int threshold = 48; // Ngưỡng bắt viền tối ưu cho chân dung

    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        final idx = y * width + x;

        // Sobel Gradient X & Y
        final gx = (grayscale[(y - 1) * width + (x + 1)] +
                2 * grayscale[y * width + (x + 1)] +
                grayscale[(y + 1) * width + (x + 1)]) -
            (grayscale[(y - 1) * width + (x - 1)] +
                2 * grayscale[y * width + (x - 1)] +
                grayscale[(y + 1) * width + (x - 1)]);

        final gy = (grayscale[(y + 1) * width + (x - 1)] +
                2 * grayscale[(y + 1) * width + x] +
                grayscale[(y + 1) * width + (x + 1)]) -
            (grayscale[(y - 1) * width + (x - 1)] +
                2 * grayscale[(y - 1) * width + x] +
                grayscale[(y - 1) * width + (x + 1)]);

        final mag = math.min(255, (gx.abs() + gy.abs()) ~/ 2);

        final outIdx = idx * 4;
        if (mag > threshold) {
          // Điểm viền: Nét trắng tinh khiết với độ rõ nét cao
          outputRgba[outIdx] = 255; // R
          outputRgba[outIdx + 1] = 255; // G
          outputRgba[outIdx + 2] = 255; // B
          outputRgba[outIdx + 3] = math.min(255, (mag * 1.5).toInt()); // Alpha
        } else {
          // Nền: Hoàn toàn trong suốt
          outputRgba[outIdx] = 0;
          outputRgba[outIdx + 1] = 0;
          outputRgba[outIdx + 2] = 0;
          outputRgba[outIdx + 3] = 0;
        }
      }
    }

    // 4. Tạo lại ui.Image từ mảng pixel RGBA mới
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      outputRgba,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (img) => completer.complete(img),
    );
    final contourImage = await completer.future;

    // 5. Xuất ra định dạng PNG ByteData
    final pngBytes = await contourImage.toByteData(format: ui.ImageByteFormat.png);
    if (pngBytes == null) {
      throw Exception('Lỗi khi xuất ảnh PNG nét viền');
    }

    // 6. Lưu file vào thư mục Cache tạm thời của ứng dụng
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${tempDir.path}/custom_pose_$timestamp.png');
    await file.writeAsBytes(pngBytes.buffer.asUint8List());

    return file.path;
  }

  /// Trích xuất từ file ảnh có sẵn trên ổ đĩa
  Future<String> extractLineArtFromFile(File file) async {
    final bytes = await file.readAsBytes();
    return extractLineArtFromBytes(bytes);
  }
}
