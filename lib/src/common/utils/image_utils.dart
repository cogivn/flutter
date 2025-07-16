import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'url_utils.dart';

class ImageUtils {
  static Widget _defaultPlaceholder() => Shimmer.fromColors(
      period: 900.milliseconds,
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(color: Colors.grey));

  static Widget load(
    String url, {
    double? width,
    double? height,
    BlendMode? colorBlendMode,
    WidgetBuilder? errorBuilder,
    WidgetBuilder? placeholder,
    BoxFit? fit = BoxFit.cover,
    Color? color,
  }) {
    if (!URLLauncherUtils.isValidUrl(url)) {
      final file = File(url);
      if (file.existsSync()) {
        return Image.file(file);
      }
      return _defaultPlaceholder();
    }
    return CachedNetworkImage(
      key: Key(url),
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      colorBlendMode: colorBlendMode,
      placeholder: (context, url) =>
          placeholder?.call(context) ?? _defaultPlaceholder(),
      errorWidget: (context, url, error) =>
          errorBuilder?.call(context) ?? _defaultPlaceholder(),
      fadeOutDuration: 300.milliseconds,
      fadeInDuration: 300.milliseconds,
    );
  }

  static Widget loadSilent(
    String url, {
    double? width,
    double? height,
    // If the icon is larger than the container size, adding padding to the container will make the icon not centered.
    // Therefore, it is important to make sure that the iconSize property of the Icon widget is always smaller than the size of the parent container.
    // errorIconSize = parentWidth-paddingLeft-paddingRight
    double? errorIconSize = 16,
    BlendMode? colorBlendMode,
    BoxFit? fit = BoxFit.cover,
  }) {
    return load(
      url,
      fit: fit,
      width: width,
      height: height,
      colorBlendMode: colorBlendMode,
      errorBuilder: (context) => Center(
        child: Icon(
          Icons.error,
          size: errorIconSize,
          color: Colors.white,
        ),
      ),
    );
  }

  static Widget loadCircleAvatar(
    String url, {
    required double radius,
    double? width,
    double? height,
    double strokeWidth = 0,
    WidgetBuilder? loadingBuilder,
    BlendMode? colorBlendMode,
    BoxFit? fit = BoxFit.cover,
    Color? backgroundColor = Colors.white,
    WidgetBuilder? errorBuilder,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: CircleAvatar(
        radius: radius - strokeWidth,
        backgroundColor: backgroundColor,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          width: double.infinity,
          height: double.infinity,
          child: load(
            url,
            width: width,
            height: height,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
