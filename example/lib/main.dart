// ignore_for_file: avoid_print

import 'package:Raven_BVN_VERF/raven_bvn_verifcation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: ElatechLiveliness()));
}

class ElatechLiveliness extends StatefulWidget {
  const ElatechLiveliness({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ElatechLiveliness();
  }
}

class _ElatechLiveliness extends State<ElatechLiveliness> {
  Map<String, dynamic> value = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // value != ""
          //     ? Image.file(File(value), key: UniqueKey())
          //     : const SizedBox(),
          const Text("Press The Button To Take Photo"),
          ElevatedButton(
              onPressed: () async {
                try {
                  value = await RavenVer.bvnVerifcation(
                    appToken: "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
                    context: context,
                    authToken: "ZYXWVUTSRQPOMNLKJIHGFEDCBA",
                    bvn: "1000000001",
                    assetLogo: "assets/raven_logo_white.png",
                  );
                } catch (ex) {
                  print(ex.toString());
                }
              },
              child: const Text("Click Me"))
        ]),
      ),
    );
  }
}
