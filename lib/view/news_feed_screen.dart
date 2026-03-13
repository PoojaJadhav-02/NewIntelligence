import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../storage/get_storage.dart';
import '../utils/app_color.dart';
import '../utils/route/route_name.dart';
import '../utils/utils.dart';
import '../view_model/news_provider.dart';
import '../view_model/theme_provider.dart';
import 'article_detail.dart';
import 'favorites_screen.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {

  final ScrollController _scrollController = ScrollController();
  LogoutClass logoutClass = LogoutClass();

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<NewsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchAllArticleList();
      provider.loadFavorites();
      provider.searchController.clear();
    });

    _scrollController.addListener(() {

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {

        provider.fetchAllArticleList(isLoadMore: true);

      }

    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.tertiaryColors,
        title: const Text('Home Screen'),
        leading: Consumer<ThemeProvider>(
          builder: (context, value, child) {
            return IconButton(
              icon: Icon(
                  value.isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  size: 25
              ),
              color: value.isDarkMode ? Colors.black : Colors.white,
              onPressed: () {
                value.setTheme();
              },
            );
          },
        ),

        actions:  [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesScreen(),
                ),
              );
            },
          ),

          IconButton(
            onPressed: () {
              logoutClass.showLogoutDialog(context);
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 10,)
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ValueListenableBuilder(
              valueListenable: provider.searchController,
              builder: (context, value, child) {
                return TextFormField(
                  controller: provider.searchController,
                  onChanged: provider.searchNews,
                  //     (query) {
                  //   //   provider.fetchSearchData(query,);
                  //   // },
                  decoration: InputDecoration(
                    hintText: 'Search News...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    prefixIcon: const Icon(Icons.search),

                    suffixIcon: value.text.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        provider.searchController.clear();
                        provider.fetchAllArticleList();
                      },
                      icon: const Icon(Icons.clear),
                    )
                        : null,
                  ),
                );
              },
            ),
          ),


          Consumer<NewsProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final articles = provider.allNewsModel?.articles ?? [];

              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: articles.length + 1,
                  itemBuilder: (context, index) {

                    if (index < articles.length) {

                      final article = articles[index];

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: SizedBox(
                            width: 70,
                            height: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                article.urlToImage ?? "",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.newspaper),
                                  );
                                },
                              ),
                            ),
                          ),
                          title: Text(article.title ?? 'No Title', maxLines: 2),
                          subtitle: Text(article.source.name ?? 'Unknown Source'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ArticleDetailScreen(article: article),
                              ),
                            );
                          },
                        ),
                      );

                    } else {

                      return provider.isFetchingMore
                          ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      )
                          : const SizedBox();
                    }

                  },
                ),
              );

            },
          ),
        ],
      ),
    );
  }
}


class LogoutClass {
  void showLogoutDialog(BuildContext context) {
    showCustomDialog(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      icon: Icons.logout,
      iconColor: Colors.red,
      confirmText: 'Yes',
      cancelText: 'Cancel',
      onConfirm: () async {
        // final tokenStore = Provider.of<TokenStoreProvider>(context, listen: false);

        log('Clear Token successful: ${TokenStore.clearToken()}');
        await TokenStore.clearToken();
        // await tokenStore.clearToken();

        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.login,
                (route) => false,
          );
        }
      },
    );
  }
}