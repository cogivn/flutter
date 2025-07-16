import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';

import '../extensions/build_context_dialog.dart';
import '../extensions/build_context_x.dart';
import 'image_utils.dart';
import 'url_utils.dart';

/// Configuration options for HTML rendering
class HtmlRenderConfig {
  const HtmlRenderConfig({
    this.key,
    this.anchorKey,
    this.onLinkTap,
    this.onAnchorTap,
    this.onCssParseError,
    this.onImageError,
    this.onImageTap,
    this.tagsList = const [],
    this.shrinkWrap = false,
    this.style = const {},
    this.globalStyle,
    this.extensions = const [],
    this.borderRadius = 6.0,
  });

  final Key? key;
  final GlobalKey? anchorKey;
  final OnTap? onLinkTap;
  final OnTap? onAnchorTap;
  final OnCssParseError? onCssParseError;
  final ImageErrorListener? onImageError;
  final OnTap? onImageTap;
  final List<String> tagsList;
  final bool shrinkWrap;
  final Map<String, Style> style;
  final Style? globalStyle;
  final List<HtmlExtension> extensions;
  final double borderRadius;
}

/// Extension for handling HTML images
extension ImageHtmlExtension on HtmlUtils {
  static ImageExtension createImageExtension(double borderRadius) {
    return ImageExtension(
      handleAssetImages: false,
      handleDataImages: false,
      builder: (ExtensionContext ctx) {
        final src = ctx.styledElement?.attributes['src'] ?? '';
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: ImageUtils.load(src),
        );
      },
    );
  }
}

/// Utility class for rendering HTML content with customizable styling and behavior
class HtmlUtils {
  const HtmlUtils._();

  /// Creates an HTML widget with no margins
  ///
  /// [data] is the HTML string to render
  /// [config] contains all the configuration options for rendering
  static Widget noMargin({
    required String data,
    HtmlRenderConfig config = const HtmlRenderConfig(),
  }) {
    return Builder(builder: (context) {
      final regular = context.textTheme.regular;
      final defaultStyle = config.globalStyle ??
          Style.fromTextStyle(regular).copyWith(
            padding: HtmlPaddings.all(0.0),
            margin: Margins.all(0),
          );

      return Html(
        key: config.key,
        anchorKey: config.anchorKey,
        data: data,
        onAnchorTap: config.onAnchorTap,
        onLinkTap: config.onLinkTap ?? _defaultLinkHandler(context),
        onCssParseError: config.onCssParseError,
        extensions: [
          ImageHtmlExtension.createImageExtension(config.borderRadius),
          ...config.extensions,
        ],
        shrinkWrap: config.shrinkWrap,
        style: {
          'body': defaultStyle,
          'p': defaultStyle.copyWith(
            margin: Margins.only(left: 4, right: 4, top: 0, bottom: 10),
          ),
          ...config.style,
        },
      );
    });
  }

  /// Creates an HTML widget with default margins
  ///
  /// Similar to [noMargin] but includes default margin styling
  static Widget standard({
    required String data,
    HtmlRenderConfig config = const HtmlRenderConfig(),
  }) {
    return noMargin(
      data: data,
      config: config,
    );
  }

  /// Creates a compact HTML widget for dense layouts
  ///
  /// Similar to [noMargin] but with reduced spacing and padding
  static Widget compact({
    required String data,
    HtmlRenderConfig config = const HtmlRenderConfig(),
  }) {
    return Builder(builder: (context) {
      final regular = context.textTheme.regular.copyWith(
        height: 1.2,
        fontSize: 14,
      );

      final compactStyle = Style.fromTextStyle(regular).copyWith(
        padding: HtmlPaddings.all(0.0),
        margin: Margins.all(0),
      );

      return noMargin(
        data: data,
        config: HtmlRenderConfig(
          key: config.key,
          style: {
            'body': compactStyle,
            'p': compactStyle,
            ...config.style,
          },
          shrinkWrap: true,
          extensions: config.extensions,
        ),
      );
    });
  }

  /// Default repository for tapping links in HTML content
  ///
  /// Handles different URL types including:
  /// - Regular web URLs
  /// - Email links (mailto:)
  /// - Phone numbers (tel:)
  /// - Other supported URL schemes
  static OnTap _defaultLinkHandler(BuildContext context) {
    return (String? url, _, __) {
      if (url == null || url.isEmpty) {
        context.showError(context.s.error);
        return;
      }
      // Handle the URL appropriately based on type
      URLLauncherUtils.openUrl(url, onError: (error) {
        return context.showError('${context.s.error}: $error');
      });
    };
  }
}
