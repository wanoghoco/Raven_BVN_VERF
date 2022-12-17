// ignore_for_file: avoid_print

import 'package:Raven_BVN_VERF/raven_bvn_verifcation.dart';
import 'package:flutter/material.dart';

//flutter pub pub publish --dry-run
void main() {
  runApp(const MaterialApp(home: BVNVerification()));
}

class BVNVerification extends StatefulWidget {
  const BVNVerification({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _BVNVerification();
  }
}

class _BVNVerification extends State<BVNVerification> {
  Map<String, dynamic> value = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  print(value);
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
