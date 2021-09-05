import 'package:assyifa_chatbot/models/user_model.dart';
import 'package:assyifa_chatbot/views/landing/landing_page.dart';
import 'package:assyifa_chatbot/views/navigations/home_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel>(context);
    print('user: $user');

    // return either Home or Authenticate Widget
    if (user == null) {
      return LandingPage();
    } else {
      return HomeNavigation();
    }
  }
}
