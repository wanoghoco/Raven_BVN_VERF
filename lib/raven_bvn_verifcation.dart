import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:Raven_BVN_VERF/http_helper.dart';
import 'package:Raven_BVN_VERF/widget/progress_dialog.dart';

class RavenVer {
  static const MethodChannel _channel =
      MethodChannel("elatech_liveliness_plugin");

  static Future<Map<String, dynamic>> bvnVerifcation(
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
      // ignore: use_build_context_synchronously
      _showDialog(context);
      try {
        var response = await _serverVer(path, bvn, appToken, authToken);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        return response;
      } catch (ex) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        throw Exception('failed');
      }
      // ignore: use_build_context_synchronously

    } catch (ex) {
      throw Exception(ex.toString());
    }
  }

  /// call server to verify bvn of captured user[_serverVer]
  static Future<Map<String, dynamic>> _serverVer(
      String imagePath, bvn, appToken, authToekn) async {
    var response =
        await HttpHeler.uploadImage(imagePath, authToekn, bvn.trim());

    if (response['status'] != 'success') {
      return response;
    }
    Map map = {
      'token': appToken,
      'fname': response['data']['first_name'],
      'lname': response['data']['last_name'],
      'bvn': bvn.trim(),
    };
    var responseConfirm = await HttpHeler.postRequest(map, 'update_business');
    return responseConfirm;
  }

  /// selfie liveness plugin[_detectLiveness]
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

  ///compressing image file [_compressImage]
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

  /// show dialogu  function[_showDialog]
  static void _showDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const ProgressDialog(
              status: 'Verifying...',
            ));
  }
}
