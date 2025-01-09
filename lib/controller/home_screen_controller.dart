import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/appConfig.dart';
import 'package:news_app/model/everything_model.dart';

class HomeScreenController with ChangeNotifier {
  List<Article> articles = [];
  List<Article> sourceArticles = [];
  List<Article> trendingArticles = [];
  bool isLoading = false;
  List<Article> filteredArticles = [];
  List<Article> filteredSourceArticles = [];
  List<Article> categoryArticles = [];

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

  getNewsByCategory({required String category, String country = "us"}) async {
    log("received category :" + category);
    if (category == "All" || category == "all") {
      category = "entertainment";
      log("entertainment was initailized");
    }
    isLoading = true;
    final url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=$country&category=$category&apiKey=17805df1c36c4c94bb8f56613af2d365");
    final response = await http.get(url);

    log(response.body);
    try {
      if (response.statusCode == 200) {
        log("entered to initialise categoryarticles");
        categoryArticles =
            EverythingModel.fromJson(jsonDecode(response.body)).articles ?? [];
        filteredSourceArticles = categoryArticles.where((article) {
          return article.title != null &&
              article.title!.isNotEmpty &&
              article.urlToImage != null &&
              article.urlToImage!.isNotEmpty &&
              article.source!.name != "[Removed]";
        }).toList();
        categoryArticles = filteredSourceArticles;
      } else {
        log("error:status code:" + response.statusCode.toString());
      }
    } catch (e) {
      log("error:" + e.toString());
    }
    isLoading = false;
  }
}
