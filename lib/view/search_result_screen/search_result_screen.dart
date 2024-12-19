import 'package:flutter/material.dart';
import 'package:news_app/controller/home_screen_controller.dart';

import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  SearchResultScreen({
    super.key,
  });

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
          // leading: InkWell(
          //     onTap: () => Navigator.pop(context),
          //     child: Icon(
          //       Icons.arrow_back,
          //       color: Colors.white,
          //     )),
          // backgroundColor: Colors.black,
          ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            shrinkWrap: true,
            // itemCount: 10,
            itemCount: context.watch<HomeScreenController>().articles.length,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.green,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(context
                          .watch<HomeScreenController>()
                          .articles[index]
                          .urlToImage
                          .toString()))),
              height: 200,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              child: Text(
                context.watch<HomeScreenController>().articles[index].title ??
                    "No news articles",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}