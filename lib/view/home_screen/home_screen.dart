import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:news_app/controller/home_screen_controller.dart';
import 'package:news_app/controller/user_validation_controller.dart';
import 'package:news_app/dummydb.dart';
import 'package:news_app/view/news_details_screen/news_details_screen.dart';
import 'package:news_app/view/search_result_screen/search_result_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, country});
  String? country;
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? country;
  List categories = [];
  int count = 0;
  int? id;
  void refresh() {
    setState(() {});
  }

  void initState() {
    () async {
      context.watch<UserValidationController>().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getInt('currentUserId');
      log("id" + id.toString());
      country = widget.country != null
          ? widget.country
          : await context.read<UserValidationController>().getCountry(id ?? 0);
      log("country" + country.toString());
    };
    // category initialisation
    if (count == 0) {
      for (int i = 0; i < Dummydb.category.length; i++) {
        categories.addAll(Dummydb.category[i].keys);
      }
      log("categories:$categories");
      count++;
    }
    log("country:$country");
    super.initState();
    //trending news initialisation
    WidgetsFlutterBinding.ensureInitialized();

    initializeTrendingNews();
  }

  initializeTrendingNews() async {
    await context.read<HomeScreenController>().getTrendingNewsCountry();
    await context.read<HomeScreenController>().getNewsByCategory(
        category: Dummydb.category[clickedCategory]
                [categories[clickedCategory]] ??
            "all",
        country: country ?? "us");
  }

  int clickedCategory = 0;
  Future<void> _search(String query) async {
    if (query.isNotEmpty) {
      await context.read<HomeScreenController>().getAllSearchDetails(query);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultScreen(),
          ));
    }
  }

  void _clearSearch() {
    _searchController.clear();
  }

  void _scrollToSelectedIndex(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final categoryWidth = screenWidth /
        3; // Adjust this width based on the item width (container + padding)
    final targetOffset =
        (index * categoryWidth) - (screenWidth / 2) + (categoryWidth / 2);

    _scrollController.animateTo(
      targetOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Function to handle search input

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                searchArea(),
                const SizedBox(
                  height: 16,
                ),
                categoryArea(),
                const SizedBox(
                  height: 16,
                ),
                latestNewsArea(context),
                const SizedBox(
                  height: 16,
                ),
                followUpNewsArea()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchArea() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search for', fillColor: Color(0xffEFEFEF),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: InkWell(
            onTap: () {
              _search(_searchController.text);
            },
            child: Icon(Icons.search)), // Search icon at the start
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear), // Clear icon
                onPressed: _clearSearch,
              )
            : null, // Show clear icon only if there is text
      ),
    );
  }

  Widget categoryArea() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () async {
            _scrollToSelectedIndex(index);
            clickedCategory = index;
            await context.read<HomeScreenController>().getNewsByCategory(
                category: Dummydb.category[clickedCategory]
                    [categories[clickedCategory]],
                country: country ?? "us");
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: clickedCategory == index ? Colors.black : Colors.white,
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(50)),
            child: Text(
              "${categories[index]}",
              style: TextStyle(
                color: clickedCategory == index ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(
          width: 10,
        ),
      ),
    );
  }

  Widget latestNewsArea(BuildContext context) {
    final homeProvider = context.watch<HomeScreenController>();
    return homeProvider.trendingArticles.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Container(
            child: ExpandableCarousel.builder(
              options: ExpandableCarouselOptions(
                showIndicator: true, viewportFraction: 1.0,
                // aspectRatio: 9 / 16,
                enableInfiniteScroll: true, autoPlay: true,
                slideIndicator: CircularSlideIndicator(
                    slideIndicatorOptions:
                        SlideIndicatorOptions(indicatorRadius: 3)),
              ),
              itemBuilder: (context, index, realIndex) => InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailsScreen(
                            article: homeProvider.trendingArticles[index]),
                      ));
                },
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(
                              homeProvider.trendingArticles[index].urlToImage ??
                                  ""),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black, Colors.transparent])),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: homeProvider.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Text(
                              homeProvider.trendingArticles[index].title ??
                                  "Title Not Found",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                    ),
                  ),
                ),
              ),
              itemCount: 4,
            ),
          );
  }

  Widget followUpNewsArea() {
    final homeProvider = context.watch<HomeScreenController>();
    log(homeProvider.categoryArticles.toString());
    return homeProvider.categoryArticles.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            shrinkWrap: true,
            itemCount: homeProvider.categoryArticles.length,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailsScreen(
                            article: homeProvider.categoryArticles[index]),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black, Colors.transparent])),
                  child: Container(
                      height: 140,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(homeProvider
                                      .categoryArticles[index].urlToImage ??
                                  ""),
                              fit: BoxFit.cover),
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            homeProvider.categoryArticles[index].title
                                    .toString() ??
                                "Source Not Found",
                            style: TextStyle(
                              color: homeProvider
                                          .categoryArticles[index].urlToImage ==
                                      null
                                  ? Colors.green
                                  : Colors.white,
                            ),
                          ),
                        ],
                      )),
                ),
              );
            },
          );
  }
}
