import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_color.dart';
import '../view_model/news_provider.dart';
import 'article_detail.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context);
    final favorites = provider.favorites;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.tertiaryColors,
        title: const Text("Favorites News"),
      ),

      body: favorites.isEmpty
          ? const Center(child: Text("No Favorite News"))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final article = favorites[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
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

                    title: Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            article.source.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            provider.removeFavorite(article.url);
                          },
                        ),
                      ],
                    ),

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
              },
            ),
    );
  }
}
