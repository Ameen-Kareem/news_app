import 'package:flutter/material.dart';
import 'package:news_app/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class UserValidationController with ChangeNotifier {
  static late Database database;
  List allUsers = [];
  late String selectedCountry;
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

  addUser({
    required String name,
    required String password,
    String? email,
    required BuildContext context,
  }) async {
    await getUser();
    for (int i = 0; i < allUsers.length; i++) {
      if (allUsers[i]["name"] == name) {
        Utils.showMsg(content: "Username taken", context: context);
      }
    }
    await database.rawInsert(
        'INSERT INTO user(name, password, email,count) VALUES(?, ?, ?,?)',
        ['$name', '$password', '${email ?? "No email"}', 0]);
  }

  addCountry({required String country, required int id}) async {
    await database
        .rawUpdate('UPDATE user SET country = ? WHERE id = ?', [country, id]);
  }

  getUser() async {
    allUsers = await database.rawQuery('SELECT * FROM user');
  }

  getCountry(int userId) async {
    selectedCountry = (await database
        .rawQuery('SELECT country FROM user WHERE id = ?', [userId])) as String;
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
      await prefs.setInt('currentUserId', userDbId);
      if (allUsers[userDbId]["count"] == 0) {
        Utils.showMsg(content: "New User", context: context);
        // await database.rawUpdate('UPDATE user SET count=? WHERE id = ?',
        //     [1, allUsers[userDbId]["id"]]);
        Navigator.pushReplacementNamed(context, '/preference');
      } else {
        Utils.showMsg(content: "Old User", context: context);
        Navigator.pushReplacementNamed(context, '/nav_bar');
      }
    } else {
      Utils.showMsg(content: "Account not found", context: context);
    }
  }
}
