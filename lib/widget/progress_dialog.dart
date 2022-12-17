import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final bool willPop;
  final String? status;

  const ProgressDialog(
      {Key? key, this.willPop = true, this.status = 'Please wait...'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => willPop,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 5.0,
                ),
                const CircularProgressIndicator(
                  semanticsLabel: 'Please wait',
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff014345)),
                ),
                const SizedBox(
                  width: 25.0,
                ),
                Text(
                  status!,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
