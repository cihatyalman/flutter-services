mixin HelperMixin {
  Future<void> delay([int milliseconds = 500]) {
    return Future<void>.delayed(Duration(milliseconds: milliseconds));
  }

  String toStringDouble(double value, {int fractionDigits = 2}) {
    final res = value.toStringAsFixed(fractionDigits);
    final r1 = res.split('.').last;
    final r2 = List.generate(fractionDigits, (index) => 0).join();
    return value.toStringAsFixed(r1 == r2 ? 0 : fractionDigits);
  }

  String passingTime(DateTime? datetime) {
    if (datetime == null) {
      return " - ";
    }

    final differenceTime = DateTime.now().difference(datetime);
    String result = "";
    if (differenceTime.inMinutes < 1) {
      return "şimdi";
    } else if (differenceTime.inMinutes < 60) {
      result = "${differenceTime.inMinutes} dk";
    } else if (differenceTime.inHours < 36) {
      result = "${differenceTime.inHours} saat";
    } else if (differenceTime.inDays < 30) {
      result = "${differenceTime.inDays} gün";
    } else {
      result = "${(differenceTime.inDays ~/ 30)} ay";
    }
    return "$result önce";
  }

  String passingTimeSort(DateTime? datetime) {
    if (datetime == null) {
      return " - ";
    }

    final differenceTime = DateTime.now().difference(datetime);
    String result = "";
    if (differenceTime.inMinutes < 1) {
      result = "şimdi";
    } else if (differenceTime.inMinutes < 60) {
      result = "${differenceTime.inMinutes}dk";
    } else if (differenceTime.inHours < 36) {
      result = "${differenceTime.inHours}s";
    } else if (differenceTime.inDays < 30) {
      result = "${differenceTime.inDays}g";
    } else {
      result = "${(differenceTime.inDays ~/ 30)}ay";
    }
    return result;
  }

  String? fileSize(int? byte) {
    if (byte == null) return null;

    String result = "";
    if (byte < 1024) {
      result = "$byte b";
    } else if (byte < (1024 * 1024)) {
      result = "${(byte / 1024).ceil()} kb";
    } else if (byte < (1024 * 1024 * 1024)) {
      result = "${(byte / (1024 * 1024)).ceil()} mb";
    }
    return result;
  }
}
