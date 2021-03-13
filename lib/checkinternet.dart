import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:unsplash_demo_nova/utils/Toastclass.dart';

class CheckInternet{
   checkInternetConnection(BuildContext context ) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        ToastClass.showToast("Internet Connected");
        print('connected');

        return true;
      }
      else {
        ToastClass.showToast("No Internet Detected");
        return false;
        print('connected');
      }
    } on SocketException catch (_) {
      ToastClass.showToast("No Internet Detected");
      return false;
      print('not connected');
    }
  }
}