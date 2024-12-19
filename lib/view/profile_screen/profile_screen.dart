import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String currentUser = "Username";
  void initState() {
    () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      currentUser = await prefs.getString('currentUser') ?? "Username";
    };
    super.initState();
  }

  String profilePic = 'assets/images/default user.jpg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "My Account",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();

                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      profilePic = image.path;
                    }
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage(profilePic),
                    radius: 40,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  currentUser,
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/bookmark');
              },
              child: Row(
                children: [
                  Icon(
                    Icons.bookmark,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Bookmark",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/reset_password');
              },
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Change Password",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setBool('loggedIn', false);
                Navigator.pushNamed(context, '/login');
              },
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "LogOut",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
