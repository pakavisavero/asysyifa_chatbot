import 'package:assyifa_chatbot/services/auth.dart';
import 'package:assyifa_chatbot/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with AutomaticKeepAliveClientMixin<Account> {

  @override
  bool get wantKeepAlive => true;

  final AuthService _auth = AuthService();
  final _currentAuth = FirebaseAuth.instance;
  String _email = 'Email';
  String _name = 'User';
  String _photoUrl = '';
  bool _isLoading = true;

  void logout(BuildContext context) async {
    await _auth.signOut();
  }

  void setCurrentUserData() async {
    await _currentAuth.currentUser().then((value) {
      setState(() {
        _email = value.email;
        _name = value.displayName;
        _photoUrl = value.photoUrl;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    print(_photoUrl);
    return _isLoading ? Loading() : SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Center(
                    child: Container(
                      width: 85.0,
                      height: 85.0,
                      child: CircleAvatar(
                        backgroundImage: _photoUrl == null ? AssetImage("assets/default.jpg") : NetworkImage(_photoUrl),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(_name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                  Text(_email, style: TextStyle(fontSize: 14.0))
                ],
              ),
              SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Card(
                  color: Color(0xFFFF4F4F),
                  child: InkWell(
                    onTap: () => logout(context),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, right: 15.0, bottom: 5.0, left: 5.0),
                            child: Icon(Icons.logout_rounded,
                                size: 35.0, color: Colors.white,),
                          ),
                          Expanded(
                              child: Text(
                            'Keluar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          )),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Icon(Icons.chevron_right, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
