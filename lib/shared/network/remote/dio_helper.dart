import 'package:dio/dio.dart';

class DioHelper{
  static Dio? dio;

  //GET
  // base url ==> https://newsapi.org/
  // method (url) ==> v2/top-headlines?
  //queries ==> country=us&category=business&apiKey=cb55b2e91ef54db7845e76de69ab10fd

  static init(){
    dio = Dio(
        BaseOptions(
          baseUrl: 'https://newsapi.org/',
          receiveDataWhenStatusError: true
        ),
    );
  }

  static Future<Response> getData({
    required String url,
    required Map<String,dynamic> query,
  })async {
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }
}