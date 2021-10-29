import 'package:assyifa_chatbot/services/auth.dart';
import 'package:assyifa_chatbot/views/login.dart';
import 'package:assyifa_chatbot/views/screens/Bantuan.dart';
import 'package:assyifa_chatbot/views/screens/Invite.dart';
import 'package:assyifa_chatbot/views/screens/lembar_persetujuan.dart';
import 'package:assyifa_chatbot/views/screens/profil.dart';
import 'package:assyifa_chatbot/views/screens/profile/components/profile_menu.dart';
import 'package:assyifa_chatbot/views/screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();

  void logout(BuildContext context) async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              fit: StackFit.expand,
              // ignore: deprecated_member_use
              overflow: Overflow.visible,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/default.jpg"),
                ),
                Positioned(
                  right: -16,
                  bottom: 0,
                  child: SizedBox(
                    height: 46,
                    width: 46,
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.white),
                      ),
                      color: Color(0xFFF5F6F9),
                      onPressed: () {},
                      child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Profile",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Profil();
              }))
            },
          ),
          ProfileMenu(
            text: "Undang teman",
            icon: "assets/icons/Invite.svg",
            press: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Invite();
              }))
            },
          ),
          ProfileMenu(
            text: "Pengaturan",
            icon: "assets/icons/Settings.svg",
            press: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Setting();
              }))
            },
          ),
          ProfileMenu(
            text: "Bantuan",
            icon: "assets/icons/Question mark.svg",
            press: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Bantuan();
              }))
            },
          ),
          ProfileMenu(
            text: "Lembar Persetujuan",
            icon: "assets/icons/book.svg",
            press: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LembarPersetujuan();
              }))
            },
          ),
          ProfileMenu(
            text: "Keluar",
            icon: "assets/icons/book.svg",
            press: () async => {
              await AuthService().signOut().then(
                    (value) => {
                      Navigator.pushNamedAndRemoveUntil(context,
                          Login.routeName, (Route<dynamic> route) => false)
                    },
                  )
            },
          ),
        ],
      ),
    ));
  }
}
