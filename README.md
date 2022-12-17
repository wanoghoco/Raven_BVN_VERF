# selfie_liveness

A new Flutter Plugin for verifying BVN.




## Using


The plugin is very easy to use. to use the plugin  just call a single functions that returns a map of server response. 


```dart
import 'package:Raven_BVN_VERF/raven_bvn_verifcation.dart';


//and call and await the function to return server response in Map 
                
                
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

 
```


## IOS Requirements

update your ios/Runner/info.plist

```
<key>NSCameraUsageDescription</key>
<string>Allow Camera Permission</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Alllow photo library to store your captured image</string>


```

and ios/Podfile to

```
platform :ios, '10.0'

and run the command 'pod install'

```

 


## Example


```dart
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

```

