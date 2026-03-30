import 'package:shared_preferences/shared_preferences.dart';

enum PrefKeys {
  count("count"),
  isFirst("is_first"),
  token("token");

  final String title;
  const PrefKeys(this.title);
}

/// PrefService.instance.box.setString(PrefKeys.token.title, "");
class PrefService {
  static final PrefService instance = PrefService._internal();
  PrefService._internal();

  late SharedPreferences _box;

  SharedPreferences get box => _box;

  Future init() async {
    _box = await SharedPreferences.getInstance();
  }
}
