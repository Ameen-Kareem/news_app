import 'package:flutter/material.dart';
import 'package:news_app/view/preference_screen/preference_screen.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreferenceScreen(),
            )),
        child: Container(
          child: Text("preference screen"),
        ),
      ),
    );
  }
}
