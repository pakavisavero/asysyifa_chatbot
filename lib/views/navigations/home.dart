import 'package:assyifa_chatbot/models/journal_model.dart';
import 'package:assyifa_chatbot/shared/loading.dart';
import 'package:assyifa_chatbot/views/journal/journal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {

  @override
  bool get wantKeepAlive => true;

  String _uid;
  final _currentAuth = FirebaseAuth.instance;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _mood;
  bool _isLoading = false;

  Future<void> _setMood(String mood) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('mood', mood);
      _mood = mood;
      print(_mood);
    });
  }

  Future<void> _getMood() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await _prefs;
    //Return String
    String mood = prefs.getString('mood');
    if (mood == null)
      mood = 'biasa';
    else
      _mood = mood;
    print(mood);
    setState(() {
      _isLoading = false;
    });
  }

  void setCurrentUserData() async {
    await _currentAuth.currentUser().then((value) {
      setState(() {
        _uid = value.uid;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setCurrentUserData();
    _getMood();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _journalsStream = Firestore.instance
        .collection('journal')
        .document(this._uid)
        .collection('journal')
        .where('title', isGreaterThan: '')
        .limit(3)
        .snapshots();
    List<JournalModel> journalList = [];

    List<String> emotionImageList = [
      'happy.png',
      'neutral.png',
      'nervous.png',
      'crying.png',
      'angry.png'
    ];
    List<String> emotionNameList = [
      'Senang',
      'Biasa',
      'Takut',
      'Sedih',
      'Kesal'
    ];
    return StreamBuilder<QuerySnapshot>(
      stream: _journalsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('error');
          _isLoading = false;
          return Text('Something went wrong');
        }

        if (!snapshot.hasData)
          _isLoading = true;
        else {
          List<JournalModel> tempList = [];

          for (int i = 0; i < snapshot.data.documents.length; i++) {
            final DocumentSnapshot document = snapshot.data.documents[i];
            tempList.add(JournalModel(
                document.documentID.toString(), document['title'],
                document['content']));
          }

          _isLoading = false;
          journalList = tempList;
          print(_isLoading);
        }

        return _isLoading
            ? Loading()
            : SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                      color: Color(0xFF39A2DB),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Row(
                    children: [
                      Flexible(
                          fit: FlexFit.loose,
                          child: Text('Selamat Datang di As-Syifa!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1))),
                      Flexible(
                          fit: FlexFit.loose,
                          child: Image.asset('assets/hello_home.png'))
                    ],
                  ),
                ),
                Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          Text('Bagaimana perasaanmu saat ini?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 1)),
                          SizedBox(height: 16),
                          Row(
                            children: List.generate(emotionNameList.length,
                                    (index) {
                                  return Flexible(
                                    fit: FlexFit.loose,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async => await _setMood(
                                              emotionNameList[index]),
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: getButtonColor(
                                                    emotionNameList[index]),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Center(
                                              child: Image.asset(
                                                  'assets/${emotionImageList[index]}'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(emotionNameList[index],
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Jurnalmu',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 1)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Journal()));
                            },
                            child: Text('Selengkapnya',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600])),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: List.generate(journalList.length, (index) {
                          JournalModel journal = journalList[index];

                          final key = encrypt.Key.fromLength(32);
                          final iv = encrypt.IV.fromLength(8);
                          final encryptor = encrypt.Encrypter(encrypt.Salsa20(key));

                          encrypt.Encrypted encryptedTitle = encrypt.Encrypted.fromBase64(journal.title);
                          String journalTitle = encryptor.decrypt(encryptedTitle, iv: iv);

                          return Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Journal()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(journalTitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  getButtonColor(String emotionName) {
    if (_mood == null) {
      return Color(0xFF39A2DB);
    } else if (_mood.toLowerCase() == emotionName.toLowerCase()) {
      return Color(0xFF39A2DB);
    } else {
      return Color(0xFF707070);
    }
  }
}
