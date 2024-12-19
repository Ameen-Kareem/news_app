import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class UserValidationController with ChangeNotifier {
  static late Database database;
  List allUsers = [];
  static initialiseDb() async {
    database = await openDatabase(
      'user_credentials.db',
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE user (id INTEGER PRIMARY KEY, name TEXT, password TEXT, email TEXT,count INTEGER,country TEXT)');
      },
    );
  }

  addUser(
      {required String name, required String password, String? email}) async {
    await database.rawInsert(
        'INSERT INTO user(name, password, email) VALUES(?, ?, ?)',
        ['$name', '$password', '${email ?? "No email"}']);
  }

  getUser() async {
    allUsers = await database.rawQuery('SELECT * FROM user');
  }

  validateUser(
      {required String user,
      required String password,
      required BuildContext context}) async {
    bool validUser = false;
    int userDbId = 0;
    await getUser();
    for (int i = 0; i < allUsers.length; i++) {
      if (allUsers[i]["name"] == user && allUsers[i]["password"] == password) {
        validUser = true;
        userDbId = i;
      }
    }
    if (validUser == true) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      await prefs.setString('currentUser', '$user');

      await prefs.setInt('currentUserPlace', userDbId);
      Navigator.pushReplacementNamed(context, '/nav_bar');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Account't not found")));
    }
  }
}
