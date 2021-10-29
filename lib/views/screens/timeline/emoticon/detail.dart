import 'package:assyifa_chatbot/models/track.dart';
import 'package:assyifa_chatbot/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool _isLoading = false;
  String _uid;
  final _currentAuth = FirebaseAuth.instance;
  List<Track> trackList = [];

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  List<String> emotionImageList = [
    'happy.png',
    'neutral.png',
    'nervous.png',
    'crying.png',
    'angry.png'
  ];

  // ignore: missing_return
  String getIcon(String condition) {
    if (condition.toLowerCase() == 'senang') {
      return emotionImageList[0];
    } else if (condition.toLowerCase() == 'biasa') {
      return emotionImageList[1];
    } else if (condition.toLowerCase() == 'takut') {
      return emotionImageList[2];
    } else if (condition.toLowerCase() == 'sedih') {
      return emotionImageList[3];
    } else if (condition.toLowerCase() == 'kesal') {
      return emotionImageList[4];
    }
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
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _trackStream = Firestore.instance
        .collection('track')
        .document(this._uid)
        .collection('track')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _trackStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('error');
          _isLoading = false;
          return Text('Something went wrong');
        }

        if (!snapshot.hasData)
          _isLoading = true;
        else {
          List<Track> tempList = [];

          for (int i = 0; i < snapshot.data.documents.length; i++) {
            final DocumentSnapshot document = snapshot.data.documents[i];
            tempList.add(Track(
              title: document['title'],
              created: document['created_at'],
            ));
          }

          print("TRACK LIST : " + trackList.toString());

          trackList = tempList;
          _isLoading = false;
        }
        return _isLoading
            ? Loading()
            : Scaffold(
                appBar: AppBar(
                  title: Text('Emoticon Track'),
                ),
                body: ListView.builder(
                  itemCount: trackList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Track track = trackList[index];

                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[200],
                        ),
                        child: Card(
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                        "${DateFormat('EEEE, dd MMM').format(track.created.toDate())} (${track.title})",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset(
                                      'assets/${getIcon(track.title)}',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
