import 'package:assyifa_chatbot/models/journal_model.dart';
import 'package:assyifa_chatbot/services/database.dart';
import 'package:assyifa_chatbot/shared/custom_button.dart';
import 'package:assyifa_chatbot/shared/custom_dialog.dart';
import 'package:assyifa_chatbot/shared/loading.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddJournal extends StatefulWidget {
  const AddJournal({Key key}) : super(key: key);

  @override
  _AddJournalState createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
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

  Future addJournal() async {
    if (_formKey.currentState.validate()) {
      final key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromLength(8);
      final encryptor = encrypt.Encrypter(encrypt.Salsa20(key));

      String journalTitle =
          encryptor.encrypt(_titleController.text, iv: iv).base64;
      String journalContent =
          encryptor.encrypt(_contentController.text, iv: iv).base64;

      setState(() {
        _isLoading = true;
      });

      JournalModel journalModel =
          JournalModel('', journalTitle, journalContent);
      try {
        await DatabaseService(uid: this._uid).addJournal(journalModel);
        _showToast('Jurnal berhasil ditambahkan!', 'success');
      } catch (err) {
        _showToast(err, 'error');
      }
      setState(() {
        _isLoading = false;
        _titleController.clear();
        _contentController.clear();
      });
    }
  }

  void showErrorDialog(String error) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(title: 'Error', content: error);
        });
  }

  @override
  void initState() {
    super.initState();
    setCurrentUserData();
    fToast = FToast();
    fToast.init(context);
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Tambah Jurnal'),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton('Tambah Jurnal', () {
                addJournal();
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
