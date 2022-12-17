import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

class HttpHeler {
  static String apiEndpoint = 'https://posapi.getravenbank.com/v1/app';
  static Future<dynamic> postRequest(Map map, String api,
      {Map<String, String>? header}) async {
    var url = Uri.parse('$apiEndpoint/$api');

    try {
      http.Response response = await http.post(url, body: map, headers: header);
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      throw Exception('No internet connectivity');
    }
  }

  static Future<Map<String, dynamic>> uploadImage(
      String path, String authToekn, String typeToken) async {
    try {
      Map<String, String> map = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $authToekn'
      };

      String url = 'https://integrations.getravenbank.com/v1/image/match';

      // Find the mime type of the selected file by looking at the header bytes of the file
      final mimeTypeData =
          lookupMimeType(path, headerBytes: [0xFF, 0xD8])?.split('/');
      // Intilize the multipart request

      final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(url));
      // Attach the file in the request
      final file = await http.MultipartFile.fromPath('image', path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      // Explicitly pass the extension of the image with request body
      // Since image_picker has some bugs due which it mixes up
      // image extension with file name like this filenamejpge
      // Which creates some problem at the server side to manage
      // or verify the file extension
      // imageUploadRequest.fields['ext'] = mimeTypeData[1];

      imageUploadRequest.fields['type'] = 'bvn';
      imageUploadRequest.fields['token'] = typeToken;
      imageUploadRequest.files.add(file);
      imageUploadRequest.headers['content-type'] = 'application/json';
      imageUploadRequest.headers['Authorization'] = 'Bearer $authToekn';

      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);

        return decodedData;
      } else {
        throw Exception(response.body);
      }
    } catch (ex) {
      throw Exception(ex.toString());
    }
  }
}
