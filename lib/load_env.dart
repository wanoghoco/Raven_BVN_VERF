import 'dart:convert';
import 'dart:io';

class LoadEnv {
  static Map<String, dynamic>? env;
  static Future<Map<String, dynamic>> getEnv() async {
    if (env != null) {
      return env!;
    }
    env = await jsonDecode(File('.env').readAsStringSync());
    return env!;
  }
}
