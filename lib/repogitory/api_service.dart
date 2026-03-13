import 'dart:developer';
import 'package:dio/dio.dart';
import '../model/get_all_news_model.dart';


class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=c2d98dfb351c44d29f568e09f45af565",
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static void setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('REQUEST [${options.method}] ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('RESPONSE ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log('ERROR ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<GetAllNewsModel?> getAllArticle({int page = 1}) async {
    String url = "https://newsapi.org/v2/top-headlines?country=us&category=business&page=$page&pageSize=10&apiKey=c2d98dfb351c44d29f568e09f45af565";

    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        return GetAllNewsModel.fromJson(response.data);
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<GetAllNewsModel?> searchNewList(String query) async {
    String url = "https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=c2d98dfb351c44d29f568e09f45af565";
    log(' Search Fetching Product : $url');

    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Fetch Search Post Successful : ${response.data}');
        return GetAllNewsModel.fromJson(response.data);
      } else {
        log('Failed to Fetch Product : ${response.data}');
        return null;
      }
    } catch (e) {
      log(' Error Fetching Product : $e');
      return null;
    }
  }
}
