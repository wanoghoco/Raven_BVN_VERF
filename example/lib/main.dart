import 'package:flutter/material.dart';
import 'dart:io';
import 'package:Raven_BVN_VERF/selfie_liveness.dart';

void main() {
  runApp(const ElatechLiveliness());
}

class ElatechLiveliness extends StatefulWidget {
  const ElatechLiveliness({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ElatechLiveliness();
  }
}

class _ElatechLiveliness extends State<ElatechLiveliness> {
  String value = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            value != ""
                ? Image.file(File(value), key: UniqueKey())
                : const SizedBox(),
            const Text("Press The Button To Take Photo"),
            ElevatedButton(
                onPressed: () async {
                  value = await SelfieLiveness.detectLiveness(
                    poweredBy: "",
                    assetLogo: "assets/raven_logo_white.png",
                    compressQualityandroid: 88,
                    compressQualityiOS: 88,
                  );
                  if (value.isEmpty) {
                    return;
                  }
                  await FileImage(File(value)).evict();
                  setState(() {});
                },
                child: const Text("Click Me"))
          ]),
        ),
      ),
    );
  }
}
