import 'package:assyifa_chatbot/models/chat_model.dart';
import 'package:assyifa_chatbot/services/database.dart';
import 'package:assyifa_chatbot/shared/loading.dart';
import 'package:assyifa_chatbot/views/youtube_player.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metadata_fetch/metadata_fetch.dart' as MetadataFetch;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key key}) : super(key: key);

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> with AutomaticKeepAliveClientMixin<ChatBot> {

  @override
  bool get wantKeepAlive => true;

  final _messageInsert = TextEditingController();
  List<Map> _messages = [];
  FocusNode _chatFocusNode = FocusNode();
  final _currentAuth = FirebaseAuth.instance;
  String _photoUrl = '';
  String _uid = '';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _mood;

  void setCurrentUserData() async {
    await _currentAuth.currentUser().then((value) {
      setState(() {
        _uid = value.uid;
        _photoUrl = value.photoUrl;
      });
    });
  }

  Future<void> response(query) async {
    query = query.replaceAll(new RegExp(r'[^\w\s]+'), '');
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/service.json").build();
    Dialogflow dialogFlow =
        Dialogflow(authGoogle: authGoogle, language: Language.indonesian);
    AIResponse aiResponse = await dialogFlow.detectIntent(query);
    print(aiResponse.getListMessage().toString());
    setState(() {
      _messages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
    ChatModel chatModel = ChatModel(0, aiResponse.getListMessage()[0]["text"]["text"][0].toString(), DateTime.now());
    await DatabaseService(uid: _uid).addChat(chatModel);
    print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());
  }

  Future<Map<String, String>> getMetadata(url) async {
    var data = await MetadataFetch.extract(url);

    return {
      'image': data.image,
      'title': data.title,
      'url': data.url,
    };
  }

  void sendChatToBot([String defaultMessage, bool isTest = false]) async {
    String message = _messageInsert.text;
    if (isTest) {
      if (defaultMessage.toLowerCase() == 'biasa') message = 'halo';
      else message = 'aku $defaultMessage';
    }
    if (message.isEmpty) {
      print("empty message");
    } else {
      setState(() {
        _messages.insert(0, {"data": 1, "message": message});
      });
      response(message);
      _messageInsert.clear();
      _chatFocusNode.requestFocus();
      if (!isTest) {
        ChatModel chatModel = ChatModel(1, message, DateTime.now());
        await DatabaseService(uid: _uid).addChat(chatModel);
      }
    }
  }

  Future<void> _getMood() async {
    SharedPreferences prefs = await _prefs;
    //Return String
    String mood = prefs.getString('mood');
    _mood = mood;
    if (mood.toLowerCase() == 'biasa') sendChatToBot('halo', true);
    else sendChatToBot('aku ${_mood.toLowerCase()}', true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMood();
    setCurrentUserData();
    print(_mood);
  }

  @override
  Widget build(BuildContext context) {
    Query users = Firestore.instance.collection('chats').document(_uid).collection('chats').orderBy('created_at', descending: false);

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Map> tempMessages = [];
        if (!snapshot.hasData) return Loading();
        for (int i = 0; i < snapshot.data.documents.length; i++) {
          final DocumentSnapshot document = snapshot.data.documents[i];
            tempMessages.insert(0, {"data": document['data'], "message": document['message']});
        }
        _messages = tempMessages;
        return Container(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) => chat(
                          _messages[index]["message"].toString(),
                          _messages[index]["data"]))),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFF39A2DB),
                        ),
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: TextFormField(
                          focusNode: _chatFocusNode,
                          cursorColor: Colors.grey[300],
                          onFieldSubmitted: (val) {
                            sendChatToBot();
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _messageInsert,
                          decoration: InputDecoration(
                            hintText: "Ketikkan pesan ...",
                            hintStyle: TextStyle(color: Colors.grey[300]),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xFF053742),
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            sendChatToBot();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget chat(String message, int data) {
    RegExp regexUrl =
        new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    String url = regexUrl.stringMatch(message);
    if (url != null) message = message.replaceAll(url, '');
    return FutureBuilder(
      future: getMetadata(url),
      builder: (context, snapshot) {
        String dataUrl;
        String title;
        if (snapshot.data != null) {
          dataUrl = snapshot.data['image'];
          title = snapshot.data['title'];
          url = snapshot.data['url'];
          if (url == null) url = '';
        }
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              data == 0
                  ? Container(
                height: 50,
                width: 50,
                child:
                CircleAvatar(child: SvgPicture.asset('assets/robot.svg')),
              )
                  : Container(),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Bubble(
                    radius: Radius.circular(15.0),
                    color: data == 0 ? Color(0xFF39A2DB) : Color(0xFF053742),
                    elevation: 0.0,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                              child: Container(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                constraints: BoxConstraints(maxWidth: 200),
                                child: Text(
                                  message,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                          dataUrl == null
                              ? Container()
                              : Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      dataUrl != null && url.contains('youtube') ? SizedBox(height: 10) : SizedBox(height: 0),
                                      Container(
                                        padding: EdgeInsets.only(left: 5, right: 5),
                                        constraints: BoxConstraints(maxWidth: 200),
                                        child: GestureDetector(
                                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubePlayer(url: url))),
                                          child: Text(
                                            title,
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      dataUrl != null && url.contains('youtube') ? SizedBox(height: 10) : SizedBox(height: 0),
                                      Container(
                                          padding: EdgeInsets.only(left: 5, right: 5),
                                          constraints: BoxConstraints(maxWidth: 200),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: InkWell(child: Image.network(dataUrl),
                                                  onTap: () => url.contains('youtube') ? Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubePlayer(url: url))) : print('URL invalid')
                                              ),
                                          )
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  )),
                        ],
                      ),
                    )),
              ),
              data == 1
                  ? Container(
                height: 50,
                width: 50,
                child: CircleAvatar(
                  backgroundImage: _photoUrl == null ? AssetImage("assets/default.jpg") : NetworkImage(_photoUrl),
                ),
              )
                  : Container(),
            ],
          ),
        );
      }
    );
  }
}
