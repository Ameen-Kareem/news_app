import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/appConfig.dart';
import 'package:news_app/model/everything_model.dart';
import 'package:news_app/model/source_model.dart' as source;

class HomeScreenController with ChangeNotifier {
  List<Article> articles = [];
  List<source.Source> sourceArticles = [];
  List<Article> trendingArticles = [];
  bool isLoading = false;
  List<Article> filteredArticles = [];
  List<source.Source> filteredSourceArticles = [];
  List<source.Source> categoryArticles = [];

  getAllSearchDetails(String keyword) async {
    isLoading = true;
    final url = Uri.parse(Appconfig.baseUrl +
        "everything?q=$keyword&apiKey=2b2d815cb0894c1d94bdbffcc6947e7a");
    final response = await http.get(url);

    log(response.body);
    try {
      if (response.statusCode == 200) {
        articles =
            EverythingModel.fromJson(jsonDecode(response.body)).articles ?? [];
        filteredArticles = articles.where((article) {
          return article.title != null &&
              article.title!.isNotEmpty &&
              article.urlToImage != null &&
              article.urlToImage!.isNotEmpty &&
              article.source!.id != "NOT_FOUND" &&
              article.source!.name != "[Removed]";
        }).toList();
        articles = filteredArticles;
      } else {
        log("error:status code:" + response.statusCode.toString());
      }
    } catch (e) {
      log("error:" + e.toString());
    }
    isLoading = false;
  }

  getTrendingNewsCountry({String country = 'us'}) async {
    isLoading = true;
    final url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=$country&apiKey=2b2d815cb0894c1d94bdbffcc6947e7a");
    final response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        trendingArticles =
            EverythingModel.fromJson(jsonDecode(response.body)).articles ?? [];
        filteredArticles = trendingArticles.where((article) {
          return article.title != null &&
              article.title!.isNotEmpty &&
              article.urlToImage != null &&
              article.urlToImage!.isNotEmpty &&
              article.source!.id != "NOT_FOUND" &&
              article.source!.name != "[Removed]";
        }).toList();
        trendingArticles = filteredArticles;
      } else {
        log("error:status code:" + response.statusCode.toString());
      }
    } catch (e) {
      log("error:" + e.toString());
    }
    isLoading = false;
  }

  getNewsByCategory(String category) async {
    if (category == "All") {
      category = "entertainment";
    }
    log("passed the all boundary condition");
    isLoading = true;
    final url = Uri.parse(
        "https://newsapi.org/v2/top-headlines/sources?category=$category&apiKey=17805df1c36c4c94bb8f56613af2d365");
    final response = await http.get(url);
    log("message" + response.body);
    log(response.statusCode.toString());
    try {
      if (response.statusCode == 200) {
        log("message:status code:" + response.statusCode.toString());
        categoryArticles =
            source.SourceModel.fromJson(jsonDecode(response.body)).sources ??
                [];
        log("raw category:" + categoryArticles.toString());
        filteredSourceArticles = categoryArticles.where((sources) {
          return sources.name != null &&
              sources.name!.isNotEmpty &&
              sources.url != null &&
              sources.url!.isNotEmpty;
        }).toList();
        log("filetered category:" + filteredArticles.toString());
        categoryArticles = filteredSourceArticles;
        log("category:" + categoryArticles.toString());
      } else {
        log("error:status code:" + response.statusCode.toString());
      }
    } catch (e) {
      log("error:" + e.toString());
    }
    isLoading = false;
  }
}
