import 'dart:math';

class TextConstants {
  static String apiUrl = "http://127.0.0.1:5000";
  static String get randomImageUrl =>
      "https://picsum.photos/id/${Random().nextInt(1000)}/${Random().nextInt(1000) + 600}/${Random().nextInt(1000) + 400}";
}
