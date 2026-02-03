import 'dart:io';
import 'package:flutter/material.dart';

class AdvokatImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AdvokatImage({
    Key? key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  bool _isUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    if (_isUrl(imagePath)) {
      // Jika URL dari internet
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingWidget();
        },
      );
    } else {
      // Jika file lokal
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        );
      } else {
        return _buildErrorWidget();
      }
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: Colors.grey.shade400, size: 40),
          const SizedBox(height: 8),
          Text(
            'Foto tidak tersedia',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// Widget khusus untuk CircleAvatar
class AdvokatAvatarImage extends StatelessWidget {
  final String imagePath;
  final double radius;

  const AdvokatAvatarImage({
    Key? key,
    required this.imagePath,
    this.radius = 35,
  }) : super(key: key);

  bool _isUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    if (_isUrl(imagePath)) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imagePath),
        onBackgroundImageError: (exception, stackTrace) {},
        child: Container(), // Fallback jika error
      );
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        return CircleAvatar(
          radius: radius,
          backgroundImage: FileImage(file),
        );
      } else {
        return CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey.shade300,
          child: Icon(Icons.person, size: radius, color: Colors.grey.shade600),
        );
      }
    }
  }
}