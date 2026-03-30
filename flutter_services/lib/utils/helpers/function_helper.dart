// import 'package:url_launcher/url_launcher.dart';

import '../../services/toolkit/mixins/helper_mixin.dart';

final hf = FunctionHelper();

class FunctionHelper with HelperMixin {
  double changeOrder(List dataList, int index) {
    double newOrderNo = 0;
    if (index == 0) {
      if (dataList.isEmpty) {
        newOrderNo = 100;
      } else {
        newOrderNo = dataList.first.orderNo! + 100;
      }
    } else if (index == dataList.length) {
      newOrderNo = dataList.last.orderNo! / 2;
    } else {
      newOrderNo =
          (dataList[index - 1].orderNo! + dataList[index].orderNo!) / 2;
    }
    return newOrderNo;
  }

  // #region url_launcher ( https://pub.dev/packages/url_launcher )
  // Future<void> _launchUrl(String url, {String? msg}) async {
  //   bool result = true;
  //   final uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
  //       result = false;
  //     }
  //   } else {
  //     result = false;
  //   }
  //   if (!result) {
  //     msg ??= "Beklenmedik bir hata oldu";
  //     CustomNotify(message: msg).show(navigatorKey.currentContext!);
  //   }
  // }

  // void openUrl(String url) {
  //   _launchUrl(url, msg: "Url açılamadı !");
  // }

  // void callPhone(String number) {
  //   _launchUrl("tel:$number", msg: "Arama yapılamadı !");
  // }

  // void sendEmail(String emailAddress, String? subject, String? body) {
  //   String url = "mailto:$emailAddress";
  //   if (subject != null) {
  //     url += "?subject=${Uri.encodeComponent(subject)}";
  //     if (body != null) {
  //       url += "&body=${Uri.encodeComponent(body)}";
  //     }
  //   }
  //   _launchUrl(url);
  // }
  // #endregion
}
