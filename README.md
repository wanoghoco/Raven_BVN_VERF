# selfie_liveness

A new Flutter Plugin for detecting liveness.




## Using


The plugin is very easy to use. to use the plugin  just call a single functions that returns the file/image path of the captured user. 


```dart
import 'package:Raven_BVN_VERF/raven_bvn_verifcation.dart';


//and call and await the function to return server response in Map 
                
                
                 try {
                    value = await RavenBVNVerification.performVerification(
                      appToken: "",
                      context: context,
                      authToken: "",
                      bvn: "",
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
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:selfie_liveness/selfie_liveness.dart';

void main() {
  runApp(ElatechLiveliness());
}

class ElatechLiveliness extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ElatechLiveliness();
  }
}

class _ElatechLiveliness extends State<ElatechLiveliness> {
  String value = "";
//asset image required
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            value != ""
                ? Image.file(new File(value), key: UniqueKey())
                : const SizedBox(),
            Text("Press The Button To Take Photo"),
            ElevatedButton(
                onPressed: () async {
                   value = await SelfieLiveness.detectLiveness(
                    poweredBy: "",
                    assetLogo: "assets/raven_logo_white.png",
                    compressQualityandroid: 88,
                    compressQualityiOS: 88,
                  );
                  setState(() {});
                },
                child: const Text("Detect Liveness"))
          ]),
        ),
      ),
    );
  }
 
}

```

