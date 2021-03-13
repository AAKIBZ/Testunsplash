import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:unsplash_demo_nova/models/model.dart';

import '../checkinternet.dart';
import 'keys.dart';

/// api class for the awesome app photos
class UnsplashImageProvider {
  int interner = 1;
  final String BASE_URL = "https://api.unsplash.com/photos?page=1&per_page=30";
  static List<UnsplashModel> res = <UnsplashModel>[];
  static Future<List> getImagesFromUnsplash(BuildContext context) async {

    ///here is the main logic we save the users data in a local cache this file can latter be updated and the new data replaces the old data
    String filename = "userimages.json";
    var dir = await getTemporaryDirectory();
    File file = new File(dir.path + "/" + filename);
    dynamic check= await CheckInternet().checkInternetConnection(context);
    print('CHCEK'+check.toString());

    if (file.existsSync() && check == false) {
      print("loading from cache");
      var jsondata = file.readAsStringSync();
      res= unsplashModelFromJson(jsondata);
      return res;
    }
    else {
      print("loading from api");
      http.Response response = await http.get(
          Uri.parse("https://api.unsplash.com/photos?page=1&per_page=30"),
          headers: {
            "Authorization": 'Client-ID ${Keys.UNSPLASH_API_CLIENT_ID}'
          });

      switch (response.statusCode) {
        case 200:
        ///OK
          String jsonresponse = response.body;
          if(file.existsSync()){
            file.deleteSync(recursive: true);
            print("previous deleted");
          }
          file.writeAsStringSync(jsonresponse,
              flush: true, mode: FileMode.WRITE);
          print('The data has been saved in cache and the data is like this');
          res =unsplashModelFromJson(response.body);
          return res;
          // String json1 = await response.transform(utf8.decoder).join();
          // return jsonDecode(json1);
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

//    static Future<List> SWAPDATA(List<UnsplashModel> Data ) async{
//       switch(ToastClass.INTERNET){
//         case 1:
//           print('Using Internet'+ToastClass.INTERNET.toString());
//           return await Data;
//           break;
//         case 2:
//           print('Using local cache'+ToastClass.INTERNET.toString());
//           return await Data;
//
//           break;
//         default:
//           ToastClass.showToast("Something Unexpected Has Occurred");
//           break;
//       }
//
// }


}

///  loads a list of latest images on the website.
// static Future<List> loadImages({int page = 1, int perPage = 20}) async {
//   String url = 'https://api.unsplash.com/photos?page=$page&per_page=$perPage';
//   var data = await getImage(url);
//   List<UnsplashImageModel> images =
//       List<UnsplashImageModel>.generate(data.length, (index) {
//     return UnsplashImageModel(data[index]);
//   });
//   return images;
// }

/// Receive image data from a given [url] and return the JSON decoded the data.
// static dynamic getImage(String url) async {
//   HttpClient httpClient = HttpClient();
//   HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
//   request.headers
//       .add('Authorization', 'Client-ID ${Keys.UNSPLASH_API_CLIENT_ID}');
//   HttpClientResponse response = await request.close();
//
//   /// Handle the api data according to the response that has been received for the server
//   switch (response.statusCode) {
//     case 200:
//
//       ///OK
//       String json1 = await response.transform(utf8.decoder).join();
//
//       return jsonDecode(json1);
//       break;
//     case 400:
//
//       /// display the error message according to the error
//       ///bad request
//       print("bad request error: ${response.statusCode}");
//       return [];
//       break;
//     case 403:
//
//       ///Forbidden
//       print("forbidden  error: ${response.statusCode}");
//       return [];
//       break;
//     case 404:
//
//       /// Not Found
//       print("not found error: ${response.statusCode}");
//       return [];
//       break;
//     default:
//
//       /// Something unexpected has occurred
//       print("unexpected error: ${response.statusCode}");
//       return [];
//       break;
//   }
// }
// }

/// checks whether there is internet or not
/// /// checks whether there is internet or not

