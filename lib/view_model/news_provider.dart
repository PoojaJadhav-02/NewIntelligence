

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import '../model/get_all_news_model.dart';
import '../repogitory/api_service.dart';


class NewsProvider extends ChangeNotifier {
  GetAllNewsModel? _allNewsModel;
  bool _isLoading = false;

  GetAllNewsModel? get allNewsModel => _allNewsModel;
  bool get isLoading => _isLoading;

  int _page = 1;
  bool _isFetchingMore = false;

  bool get isFetchingMore => _isFetchingMore;

  DioClient api = DioClient();

  List<Article>? _originalList = [];
  List<Article>? get originalList => _originalList;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;


  Timer? _debounce;

  void searchNews(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchSearchData(query);
    });
  }

  set allProductModel(GetAllNewsModel? value){
    _allNewsModel = value;
    notifyListeners();
  }

  // Future<void> fetchAllArticleList()async {
  //   final result = await api.getAllArticle();
  //   allProductModel = result;
  //   _originalList = List<Article>.from(result?.articles ?? []);
  //   notifyListeners();
  //   // print('Resultt All Product : $allProductModel');
  // }

  Future<void> fetchAllArticleList({bool isLoadMore = false}) async {

    if (_isFetchingMore) return;

    if (isLoadMore) {
      _isFetchingMore = true;
      _page++;
    } else {
      _isLoading = true;
      _page = 1;
    }

    notifyListeners();

    final result = await api.getAllArticle(page: _page);

    if (result != null) {

      if (isLoadMore && _allNewsModel != null) {

        _allNewsModel!.articles.addAll(result.articles);

      } else {

        _allNewsModel = result;

      }

      _originalList = List<Article>.from(_allNewsModel?.articles ?? []);
    }

    _isLoading = false;
    _isFetchingMore = false;

    notifyListeners();
  }


  /// Search Logic
  Future<void> fetchSearchData(String query) async {
    if (query.isEmpty) {
      await fetchAllArticleList();
      return;
    }

    _isLoading = true;
    notifyListeners();

    final result = await api.searchNewList(query);
    _allNewsModel = result;

    _isLoading = false;
    notifyListeners();
  }


   /// favourite function

  final GetStorage _storage = GetStorage();

  static const String favoriteKey = "favorites";

  List<Article> _favorites = [];

  List<Article> get favorites => _favorites;

  bool isFavorite(String url) {

    return _favorites.any((item) => item.url == url);

  }

  void loadFavorites() {

    final data = _storage.read(favoriteKey) ?? [];

    _favorites = List<Article>.from(
      data.map((e) => Article.fromJson(Map<String, dynamic>.from(e))),
    );

    notifyListeners();
  }

  void addFavorite(Article article) {

    _favorites.add(article);

    _storage.write(
      favoriteKey,
      _favorites.map((e) => e.toJson()).toList(),
    );

    notifyListeners();
  }


  void removeFavorite(String url) {

    _favorites.removeWhere((item) => item.url == url);

    _storage.write(
      favoriteKey,
      _favorites.map((e) => e.toJson()).toList(),
    );

    notifyListeners();
  }


  void toggleFavorite(Article article) {

    if (isFavorite(article.url)) {

      removeFavorite(article.url);

    } else {

      addFavorite(article);

    }

    notifyListeners();
  }



}