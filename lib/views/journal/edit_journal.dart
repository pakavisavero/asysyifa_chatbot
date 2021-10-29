import 'package:assyifa_chatbot/models/journal_model.dart';
import 'package:assyifa_chatbot/services/database.dart';
import 'package:assyifa_chatbot/shared/custom_button.dart';
import 'package:assyifa_chatbot/shared/custom_dialog.dart';
import 'package:assyifa_chatbot/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EditJournal extends StatefulWidget {
  final JournalModel journal;

  const EditJournal({Key key, this.journal}) : super(key: key);

  @override
  _EditJournalState createState() => _EditJournalState();
}

class _EditJournalState extends State<EditJournal> {
  TextEditingController _titleController;
  TextEditingController _contentController;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  FToast fToast;

  String _uid;
  final _currentAuth = FirebaseAuth.instance;

  void setCurrentUserData() async {
    await _currentAuth.currentUser().then((value) {
      setState(() {
        _uid = value.uid;
      });
    });
  }

  _showToast(String message, String type) {
    Color color;
    Icon icon;
    if (type == 'success') {
      color = Colors.green;
      icon = Icon(Icons.check, color: Colors.white);
    } else if (type == 'error') {
      color = Colors.red;
      icon = Icon(Icons.error, color: Colors.white);
    }
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(
            width: 12.0,
          ),
          Text(message, style: TextStyle(color: Colors.white)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  Future editJournal() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      final key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromLength(8);
      final encryptor = encrypt.Encrypter(encrypt.Salsa20(key));

      String journalTitle =
          encryptor.encrypt(_titleController.text, iv: iv).base64;
      String journalContent =
          encryptor.encrypt(_contentController.text, iv: iv).base64;

      JournalModel journalModel =
          JournalModel(widget.journal.docId, journalTitle, journalContent);
      try {
        await DatabaseService(uid: this._uid).editJournal(journalModel);
        _showToast('Jurnal berhasil diubah!', 'success');
      } catch (err) {
        _showToast(err.toString(), 'error');
      }
      setState(() {
        _isLoading = false;
        _titleController.clear();
        _contentController.clear();
      });
      Navigator.pop(context);
    }
  }

  void showErrorDialog(String error) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(title: 'Error', content: error);
        });
  }

  void showDeletionDialog(JournalModel journalModel) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hapus Kontak'),
            content: Text('Yakin untuk menghapus jurnal?'),
            actions: [
              TextButton(
                onPressed: () {
                  print('Cancel deletion');
                  Navigator.pop(context);
                },
                child: Text('Batal', style: TextStyle(fontSize: 16.0)),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  Navigator.pop(context);
                  await DatabaseService(uid: _uid)
                      .deleteJournal(journalModel.docId);
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pop(context);
                },
                child: Text('Hapus',
                    style: TextStyle(color: Color(0xFFFF4F4F), fontSize: 16.0)),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    setCurrentUserData();
    fToast = FToast();
    fToast.init(context);

    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(8);
    final encryptor = encrypt.Encrypter(encrypt.Salsa20(key));

    encrypt.Encrypted encryptedTitle =
        encrypt.Encrypted.fromBase64(widget.journal.title);
    encrypt.Encrypted encryptedContent =
        encrypt.Encrypted.fromBase64(widget.journal.content);
    String journalTitle = encryptor.decrypt(encryptedTitle, iv: iv);
    String journalContent = encryptor.decrypt(encryptedContent, iv: iv);

    _titleController = TextEditingController(text: journalTitle);
    _contentController = TextEditingController(text: journalContent);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Ubah Jurnal'),
              actions: [
                InkWell(
                  onTap: () {
                    showDeletionDialog(widget.journal);
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton('Ubah Jurnal', () {
                editJournal();
              }),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: 'Judul',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _contentController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        validator: (value) => value.toString().trim().isEmpty
                            ? 'Jurnal tidak boleh kosong'
                            : null,
                        decoration: InputDecoration(
                          hintText: 'Tuliskan jurnalmu di sini',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
