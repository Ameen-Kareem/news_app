import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:news_app/controller/user_validation_controller.dart';
import 'package:news_app/dummydb.dart';
import 'package:news_app/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:news_app/view/home_screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceScreen extends StatefulWidget {
  PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  List allCountries = [];
  int count = 0;
  String? selectedCountry;

  void initState() {
    () async {
      await context.watch<UserValidationController>().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getInt('currentUserId');
    };
    for (int i = 0; i < Dummydb.countries.length; i++) {
      allCountries.addAll(Dummydb.countries[i].keys);
    }
    super.initState();
  }

  int? selectedIndex;
  int? id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          right: 20.0,
          left: 20,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                "Choose your country",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    childAspectRatio: 9 / 3,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2),
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    await context.read<UserValidationController>().addCountry(
                        country: Dummydb.countries[index]
                            ["${allCountries[index]}"],
                        id: id ?? 0);

                    selectedCountry =
                        Dummydb.countries[index]["${allCountries[index]}"];
                    selectedIndex = index;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? Colors.white
                            : Colors.black,
                        border: Border.all(
                          width: 1,
                          color: selectedIndex == index
                              ? Colors.black
                              : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: Text(
                      "${allCountries[index]}",
                      style: TextStyle(
                        color: selectedIndex == index
                            ? Colors.black
                            : Colors.white,
                      ),
                    )),
                  ),
                ),
                itemCount: allCountries.length,
              ),
            ),
            if (selectedCountry != null)
              InkWell(
                onTap: () async {
                  await context.read<UserValidationController>().addCountry(
                      country: selectedCountry ?? 'us', id: id ?? 0);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BottomNavBar(country: selectedCountry!)));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                      child: Text(
                    "Get Started",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              )
          ],
        ),
      ),
    );
  }
}
