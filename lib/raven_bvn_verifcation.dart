import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:Raven_BVN_VERF/http_helper.dart';
import 'package:Raven_BVN_VERF/widget/progress_dialog.dart';

class RavenBVNVerification {
  static const MethodChannel _channel =
      MethodChannel("elatech_liveliness_plugin");

  static Future<Map<String, dynamic>> performVerification(
      {required BuildContext context,
      required String bvn,
      required String appToken,
      required String authToken,
      String poweredBy = "",
      String assetLogo = "",
      int compressQualityiOS = 70,
      int compressQualityandroid = 30}) async {
    try {
      String path = await _detectLiveness(
          poweredBy: poweredBy,
          assetLogo: assetLogo,
          compressQualityiOS: compressQualityiOS,
          compressQualityandroid: compressQualityandroid);
      if (path.isEmpty) {
        throw Exception("path is empty. user didn't take photo");
      }
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => const ProgressDialog(
                status: 'Verifying...',
              ));

      var response = await HttpHeler.uploadImage(
          path,
          'https://integrations.getravenbank.com/v1/image/match',
          'image',
          bvn.trim());
      if (response['status'] != 'success') {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        return response;
      }

      Map map = {
        'token': appToken,
        'fname': response['data']['first_name'],
        'lname': response['data']['last_name'],
        'bvn': bvn.trim(),
      };
      var responseConfirm = await HttpHeler.postRequest(map, 'update_business');
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      return responseConfirm;
    } catch (ex) {
      throw Exception();
    }
  }

  static Future<String> _detectLiveness(
      {required String poweredBy,
      required String assetLogo,
      required int compressQualityiOS,
      required int compressQualityandroid}) async {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      throw Exception('platform not supported');
    }
    var response = await _channel.invokeMethod("detectliveliness", {
          "msgselfieCapture": "Place your face inside the oval shaped panel",
          "msgBlinkEye": defaultTargetPlatform == TargetPlatform.iOS
              ? "Blink 3 Times"
              : "Blink Your Eyes",
          "assetPath": assetLogo,
          "poweredBy": poweredBy
        }) ??
        "";
    if (response == "") {
      return "";
    }

    File file = File(response);
    try {
      var data = await _compressImage(
          file: file,
          compressQualityandroid: compressQualityandroid,
          compressQualityiOS: compressQualityiOS);

      return data.path;
    } catch (ex) {
      return file.path;
    }
  }

  //comopression

  static Future<File> _compressImage(
      {required File file,
      required int compressQualityandroid,
      required int compressQualityiOS}) async {
    Directory tempDir = await getTemporaryDirectory();
    print(tempDir.path);
    String dir = "${tempDir.absolute.path}/test.jpeg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      dir,
      quality: TargetPlatform.iOS == defaultTargetPlatform
          ? compressQualityiOS
          : compressQualityandroid,
    );

    return result!;
  }

  static String getVideoExtension(String filePath) {
    List<String> data = filePath.split(".");
    return data[data.length - 1];
  }
}
