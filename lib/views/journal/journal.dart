import 'package:assyifa_chatbot/models/journal_model.dart';
import 'package:assyifa_chatbot/shared/loading.dart';
import 'package:assyifa_chatbot/views/journal/add_journal.dart';
import 'package:assyifa_chatbot/views/journal/edit_journal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class Journal extends StatefulWidget {
  const Journal({Key key}) : super(key: key);

  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {

  bool _isLoading = false;
  String _uid;
  final _currentAuth = FirebaseAuth.instance;

  void setCurrentUserData() async {
    await _currentAuth.currentUser().then((value) {
      setState(() {
        _uid = value.uid;
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
    final Stream<QuerySnapshot> _journalsStream = Firestore.instance
        .collection('journal')
        .document(this._uid)
        .collection('journal')
        .orderBy('created_at', descending: true)
        .snapshots();
    List<JournalModel> journalList = [];

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

        return _isLoading ? Loading() : Scaffold(
            appBar: AppBar(
              title: Text('Jurnal'),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddJournal()));
              },
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  itemCount: journalList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final key = encrypt.Key.fromLength(32);
                    final iv = encrypt.IV.fromLength(8);
                    final encryptor = encrypt.Encrypter(encrypt.Salsa20(key));

                    JournalModel journal = journalList[index];
                    encrypt.Encrypted encryptedTitle = encrypt.Encrypted.fromBase64(journal.title);
                    encrypt.Encrypted encryptedContent = encrypt.Encrypted.fromBase64(journal.content);
                    String journalTitle = encryptor.decrypt(encryptedTitle, iv: iv);
                    String journalContent = encryptor.decrypt(encryptedContent, iv: iv);

                    return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Colors.black.withOpacity(0.6),
                            width: 1.2,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditJournal(journal: journal)));
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                journalTitle.isEmpty ? Container() : Text(journalTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16)),
                                journalTitle.isEmpty ? Container() : SizedBox(height: 5),
                                Text(journalContent,
                                    maxLines: 8,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        ));
                  }),
            ));
      });
  }
}
