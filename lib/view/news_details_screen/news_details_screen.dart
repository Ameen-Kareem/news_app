import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_app/model/everything_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsScreen extends StatelessWidget {
  NewsDetailsScreen({super.key, required this.article});
  Article article;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              height: 200,
              margin: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article.urlToImage ?? "",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Text(
                article.title ?? "",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                article.content ?? "",
                maxLines: 5,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                _launchUrl(article.url ?? "");
              },
              child: Container(
                margin: EdgeInsets.all(10),
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Read More",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ));
  }

  Future<void> _launchUrl(String urlToLaunch) async {
    final _url = Uri.parse(urlToLaunch);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
