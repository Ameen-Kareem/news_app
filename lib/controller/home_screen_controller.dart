import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/appConfig.dart';
import 'package:news_app/model/everything_model.dart';

class HomeScreenController with ChangeNotifier {
  List<Article> articles = [];
  getAllSearchDetails(String keyword) async {
    final url = Uri.parse(Appconfig.baseUrl +
        "everything?q=$keyword&apiKey=2b2d815cb0894c1d94bdbffcc6947e7a");
    final response = await http.get(url);

    log(response.body);
    try {
      if (response.statusCode == 200) {
        articles =
            EverythingModel.fromJson(jsonDecode(response.body)).articles ?? [];
        log("second article:" + articles.toString());
        log("response body:" + response.body);
      } else {
        log("error:status code:" + response.statusCode.toString());
      }
    } catch (e) {
      log("error:" + e.toString());
    }
  }

  getTrendingNewsCountry(String? country) {}
}
