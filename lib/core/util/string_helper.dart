final class StringHelper {
  /// Check if the url is valid and return the url with http prefix if not
  static String checkUrl(String url) {
    if (url.startsWith('http')) {
      return url;
    } else {
      return 'http://$url';
    }
  }
}
