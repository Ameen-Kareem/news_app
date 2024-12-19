import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:news_app/controller/home_screen_controller.dart';
import 'package:news_app/dummydb.dart';
import 'package:news_app/view/search_result_screen/search_result_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int clickedCategory = 0;
  // Function to clear the search input field
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
                SizedBox(
                  height: 16,
                ),
                categoryArea(),
                SizedBox(
                  height: 16,
                ),
                latestNewsArea(),
                SizedBox(
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
        itemCount: Dummydb.category.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            _scrollToSelectedIndex(index);
            clickedCategory = index;
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: clickedCategory == index ? Colors.black : Colors.white,
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(50)),
            child: Text(
              "${Dummydb.category[index]}",
              style: TextStyle(
                color: clickedCategory == index ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        separatorBuilder: (context, index) => SizedBox(
          width: 10,
        ),
      ),
    );
  }

  Widget latestNewsArea() {
    return Container(
      child: ExpandableCarousel(
        options: ExpandableCarouselOptions(
          // height: 250.0,
          showIndicator: true, viewportFraction: 1.0,
          // // aspectRatio: 9 / 16,
          enableInfiniteScroll: true, autoPlay: true,
          slideIndicator: CircularSlideIndicator(
              slideIndicatorOptions: SlideIndicatorOptions(indicatorRadius: 3)),
        ),
        items: [1, 2, 3, 4, 5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  height: 250,
                  width: double.infinity,
                  margin: EdgeInsets.only(right: 1.0),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      'Trending news ',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ));
            },
          );
        }).toList(),
      ),
    );
  }

  Widget followUpNewsArea() {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        height: 10,
      ),
      shrinkWrap: true,
      itemCount: 10,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Container(
            height: 140,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("News source ${index + 1}"),
                SizedBox(
                  height: 16,
                ),
                Text("News  title${index + 1}")
              ],
            ));
      },
    );
  }
}
