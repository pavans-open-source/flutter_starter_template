import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StringToImage extends StatelessWidget {
  final String? imagePath;
  final Uint8List? memoryImage;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const StringToImage({
    super.key,
    this.imagePath,
    this.memoryImage,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  bool _isNetworkUrl(String? path) =>
      path?.startsWith(RegExp(r'http(s)?://')) ?? false;
  bool _isSvg(String? path) => path?.endsWith('.svg') ?? false;

  @override
  Widget build(BuildContext context) {
    if (memoryImage != null) {
      return Image.memory(
        memoryImage!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => errorWidget ?? const Icon(Icons.error),
      );
    }

    if (imagePath == null) {
      return errorWidget ?? const Icon(Icons.error);
    }

    if (_isNetworkUrl(imagePath)) {
      return _isSvg(imagePath)
          ? SvgPicture.network(
              imagePath!,
              width: width,
              height: height,
              fit: fit ?? BoxFit.contain,
              placeholderBuilder: (_) =>
                  placeholder ?? const CircularProgressIndicator(),
            )
          : Image.network(
              imagePath!,
              width: width,
              height: height,
              fit: fit,
              loadingBuilder: (_, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return placeholder ??
                    Center(
                        child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ));
              },
              errorBuilder: (_, __, ___) =>
                  errorWidget ?? const Icon(Icons.error),
            );
    } else {
      return _isSvg(imagePath)
          ? SvgPicture.asset(
              imagePath!,
              width: width,
              height: height,
              fit: fit ?? BoxFit.contain,
              placeholderBuilder: (_) =>
                  placeholder ?? const CircularProgressIndicator(),
            )
          : Image.asset(
              imagePath!,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (_, __, ___) =>
                  errorWidget ?? const Icon(Icons.error),
            );
    }
  }
}
