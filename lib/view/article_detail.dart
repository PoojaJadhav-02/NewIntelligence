import 'package:flutter/material.dart';
import '../model/get_all_news_model.dart';

// class ArticleDetailScreen extends StatelessWidget {
//   final Article article;
//
//   const ArticleDetailScreen({super.key, required this.article});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Article Detail"),
//       ),
//
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             /// Image
//             article.urlToImage != null
//                 ? Image.network(
//               article.urlToImage!,
//               width: double.infinity,
//               height: 220,
//               fit: BoxFit.cover,
//             )
//                 : Container(
//               height: 220,
//               color: Colors.grey,
//               child: const Center(child: Icon(Icons.image)),
//             ),
//
//             const SizedBox(height: 15),
//
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   /// Title
//                   Text(
//                     article.title,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   /// Author
//                   Text(
//                     "Author: ${article.author ?? "Unknown"}",
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   /// Date
//                   Text(
//                     "Published: ${article.publishedAt.toString()}",
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//
//                   const SizedBox(height: 15),
//
//                   /// Description
//                   Text(
//                     article.description ?? "No description available",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   /// Content
//                   Text(
//                     article.content ?? '',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:provider/provider.dart';
import '../utils/app_color.dart';
import '../view_model/news_provider.dart';

class ArticleDetailScreen extends StatelessWidget {

  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<NewsProvider>(context);

    bool isFavorite = provider.isFavorite(article.url);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.tertiaryColors,
        title: const Text("Article Detail"),
        actions: [

          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              //color: Colors.red,
            ),
            onPressed: () {
              provider.toggleFavorite(article);
            },
          )

        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Image
            article.urlToImage != null
                ? Image.network(
              article.urlToImage!,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 220,
                  color: Colors.grey,
                  child: const Center(child: Icon(Icons.image)),
                );
              },
            )
                : Container(
              height: 220,
              color: Colors.grey,
              child: const Center(child: Icon(Icons.image)),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Title
                  Text(
                    article.title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  /// Author
                  Text(
                    "Author: ${article.author ?? "Unknown"}",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 10),

                  /// Date
                  Text(
                    "Published: ${article.publishedAt}",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 15),

                  /// Description
                  Text(
                    article.description ?? "No description available",
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  /// Content
                  Text(
                    article.content ?? "",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}