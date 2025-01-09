import 'package:flutter/material.dart';
import 'package:news_app/dummydb.dart';
import 'package:news_app/view/news_details_screen/news_details_screen.dart';
import 'package:news_app/view/preference_screen/preference_screen.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Dummydb.savedNews.isEmpty
            ? Center(
                child: Text(
                  "No Saved News",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              )
            : ListView.builder(
                itemCount: Dummydb.savedNews.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  width: 600,
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1)),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsDetailsScreen(
                                        article: Dummydb.savedNews[index])));
                          },
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              Dummydb.savedNews[index].title ?? "",
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Dummydb.savedNews.removeAt(index);
                            setState(() {});
                          },
                          child: Icon(Icons.delete))
                    ],
                  ),
                ),
              ));
  }
}
