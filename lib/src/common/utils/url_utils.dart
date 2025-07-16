import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

import 'logger.dart';

/// Function type for handling URL launch errors
typedef URLError = void Function(dynamic);

/// Utility class for handling URL operations and launching various link types
class URLLauncherUtils {
  /// Opens a URL in the appropriate application
  /// 
  /// [url] is the URL to be opened
  /// [onError] is a callback triggered when the URL cannot be opened
  /// [launchMode] determines how to open the URL (default is platform default behavior)
  static Future<void> openUrl(
    String url, {
    URLError? onError,
    LaunchMode launchMode = LaunchMode.platformDefault,
  }) async {
    // Handle URL scheme appropriately
    if (url.startsWith('http://')) {
      launchMode = LaunchMode.externalApplication;
    } else if (_isEmailUrl(url)) {
      return openEmail(_extractEmailFromUrl(url), onError: onError);
    } else if (_isPhoneUrl(url)) {
      return openPhoneCall(_extractPhoneFromUrl(url), onError: onError);
    }
    
    return await _launch(
      Uri.parse(url), 
      'Could not launch $url',
      onError: onError ?? ((err) {}), 
      mode: launchMode
    );
  }

  /// Checks if a string is a valid URL
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (exception) {
      return false;
    }
  }

  /// Opens the default phone dialer with the provided phone number
  static Future<void> openPhoneCall(String phone, {URLError? onError}) async {
    // Clean phone number formatting
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    return await _launch(
      Uri.parse('tel:$cleanPhone'),
      'Could not launch phone call to $phone',
      onError: onError ?? ((e) => logger.e(e)),
    );
  }

  /// Opens the default email client with the provided email address
  /// 
  /// The [email] parameter can be a plain email address or a mailto URL
  /// If [subject] or [body] are provided, they'll be added to or replace existing parameters
  static Future<void> openEmail(String email, {
    URLError? onError,
    String subject = '',
    String body = '',
  }) async {
    try {
      // Parse the email parameter which could be a plain email or mailto URL with existing parameters
      final emailData = _parseEmailInput(email);
      final String emailAddress = emailData.emailAddress;
      final Map<String, String> existingParams = emailData.parameters;
      
      // Merge parameters, giving priority to the ones passed to the function
      final queryParams = <String, String>{
        ...existingParams,
        if (subject.isNotEmpty) 'subject': subject,
        if (body.isNotEmpty) 'body': body,
      };
      
      // Create the complete mailto URL
      final mailtoUrl = _buildMailtoUrl(emailAddress, queryParams);
      final uri = Uri.parse(mailtoUrl);
      
      return await _launch(
        uri, 
        'Could not launch email to $emailAddress',
        onError: onError ?? ((e) => logger.e(e)),
      );
    } catch (e) {
      logger.e('Error creating email URI: $e');
      if (onError != null) {
        onError.call(e);
        return;
      }
      rethrow;
    }
  }
  
  /// Parse an email input which could be a simple email or mailto URL with parameters
  static _EmailData _parseEmailInput(String input) {
    // Default case - just an email address
    if (!input.toLowerCase().startsWith('mailto:')) {
      return _EmailData(input, const {});
    }
    
    try {
      // Parse the mailto URI
      final uri = Uri.parse(input);
      
      // Extract email address (path part of mailto:)
      final emailAddress = uri.path;
      
      // Extract existing parameters
      final parameters = uri.queryParameters;
      
      return _EmailData(emailAddress, parameters);
    } catch (e) {
      // If parsing fails, treat as simple email
      logger.e('Failed to parse mailto URL: $e');
      return _EmailData(
        input.replaceFirst(RegExp(r'mailto:', caseSensitive: false), ''),
        const {},
      );
    }
  }
  
  /// Build a properly formatted mailto URL with parameters
  static String _buildMailtoUrl(String email, Map<String, String> params) {
    String mailtoUrl = 'mailto:$email';
    
    if (params.isNotEmpty) {
      final encodedParams = params.entries.map((entry) => 
        '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}'
      ).join('&');
      
      mailtoUrl += '?$encodedParams';
    }
    
    return mailtoUrl;
  }

  /// Opens WhatsApp with the specified phone number and optional text
  static Future<void> openWhatsApp(String phone, {
    String text = 'Hi,...',
    URLError? onError,
  }) async {
    // Clean phone number formatting
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    final url = switch (Platform.operatingSystem) {
      'android' => 'whatsapp://send?phone=$cleanPhone&text=$text',
      'ios' => 'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(text)}',
      _ => '',
    };

    await _launch(
      Uri.parse(url), 
      'Could not launch WhatsApp with $phone',
      onError: onError ?? ((err) => logger.e(err)),
    );
  }

  /// Opens the maps application with the given coordinates
  static Future<void> openMap(double latitude, double longitude, {
    URLError? onError, 
    String customLink = '',
  }) async {
    if (customLink.isNotEmpty && customLink.startsWith('https')) {
      return openUrl(customLink, onError: onError);
    }

    final googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    return await _launch(
      Uri.parse(googleUrl), 
      'Could not open map location',
      onError: onError ?? ((e) => logger.e(e)),
    );
  }

  /// Opens the default calendar application
  static Future<void> openCalendar({URLError? onError}) async {
    final String link = Platform.isAndroid
      ? 'content://com.android.calendar/time/' 
      : Platform.isIOS 
        ? 'calshow://' 
        : '';
    
    if (link.isEmpty) {
      if (onError != null) {
        onError.call(Exception('Calendar launch not supported on this platform'));
      }
      return;
    }
    
    return await _launch(
      Uri.parse(link),
      'Could not launch calendar',
      onError: onError ?? ((e) => logger.e(e)),
    );
  }

  /// Checks if the URL is an email link
  static bool _isEmailUrl(String url) {
    // Improved email detection
    if (url.toLowerCase().startsWith('mailto:')) return true;
    
    // Email address pattern check (contains @ but not a web URL)
    final isEmail = url.contains('@') && 
                   !url.contains('/') && 
                   !url.startsWith('http:') && 
                   !url.startsWith('https:');
    return isEmail;
  }

  /// Extracts email address from a URL
  static String _extractEmailFromUrl(String url) {
    if (url.toLowerCase().startsWith('mailto:')) {
      return url.substring(7);
    }
    return url;
  }

  /// Checks if the URL is a phone link
  static bool _isPhoneUrl(String url) {
    return url.toLowerCase().startsWith('tel:');
  }

  /// Extracts phone number from a URL
  static String _extractPhoneFromUrl(String url) {
    if (url.toLowerCase().startsWith('tel:')) {
      return url.substring(4);
    }
    return url;
  }

  /// Core method to launch URLs
  static Future<void> _launch(
    Uri uri,
    String errorMessage, {
    URLError? onError,
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    try {
      final success = await launchUrl(uri, mode: mode);
      if (!success) {
        throw Exception('Failed to launch URL: $uri');
      }
    } catch (e) {
      logger.e('$errorMessage: $e');
      if (onError != null) {
        onError.call(e);
        return;
      }
      rethrow;
    }
  }
}

/// Helper class for storing parsed email data
class _EmailData {
  final String emailAddress;
  final Map<String, String> parameters;

  const _EmailData(this.emailAddress, this.parameters);
}