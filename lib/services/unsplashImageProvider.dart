import 'dart:convert';
import 'dart:io';
import 'package:unsplash_demo_nova/models/MianModel.dart';
import 'keys.dart';

/// api class for the awesome app photos
class UnsplashImageProvider {
  ///  loads a list of latest images on the website.
  static Future<List> loadImages({int page = 1, int perPage = 30}) async {
    String url = 'https://api.unsplash.com/photos?page=$page&per_page=$perPage';
    var data = await getImage(url);
    List<UnsplashImageModel> images =
        List<UnsplashImageModel>.generate(data.length, (index) {
      return UnsplashImageModel(data[index]);
    });
    return images;
  }

  /// Receive image data from a given [url] and return the JSON decoded the data.
  static dynamic getImage(String url) async {
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers
        .add('Authorization', 'Client-ID ${Keys.UNSPLASH_API_CLIENT_ID}');
    HttpClientResponse response = await request.close();

    /// Handle the api data according to the response that has been received for the server
    switch (response.statusCode) {
      case 200:
      ///OK
        String json = await response.transform(utf8.decoder).join();
        return jsonDecode(json);
        break;
      case 400:
         /// display the error message according to the error
        ///bad request
        print("bad request error: ${response.statusCode}");
        return [];
        break;
      case 403:

        ///Forbidden
        print("forbidden  error: ${response.statusCode}");
        return [];
        break;
      case 404:

        /// Not Found
        print("not found error: ${response.statusCode}");
        return [];
        break;
      default:
        /// Something unexpected has occurred
        print("unexpected error: ${response.statusCode}");
        return [];
        break;
    }
  }
}
