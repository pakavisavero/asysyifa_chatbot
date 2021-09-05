import 'package:assyifa_chatbot/models/chat_model.dart';
import 'package:assyifa_chatbot/models/journal_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String uid;

  DatabaseService({this.uid});


  Future<void> addChat(ChatModel chatModel) {
    CollectionReference chats = Firestore.instance.collection('chats').document(this.uid).collection('chats');
    // Call the user's CollectionReference to add a new user
    return chats
        .add({
      'data': chatModel.data,
      'message': chatModel.message,
      'created_at': FieldValue.serverTimestamp()
    })
        .then((value) => print("Chat Added"))
        .catchError((error) => print("Failed to add chat: $error"));
  }

  Future<void> addJournal(JournalModel journalModel) {
    CollectionReference journals = Firestore.instance.collection('journal').document(this.uid).collection('journal');
    // Call the CollectionReference to add a new Journal
    return journals
        .add({
      'title': journalModel.title,
      'content': journalModel.content,
      'created_at': FieldValue.serverTimestamp()
    })
        .then((value) => print("Journal Added"))
        .catchError((error) => print("Failed to add journal: $error"));
  }

  Future<void> editJournal(JournalModel journalModel) {
    CollectionReference journals = Firestore.instance.collection('journal').document(this.uid).collection('journal');
    return journals
        .document(journalModel.docId)
        .updateData({
      'title': journalModel.title,
      'content': journalModel.content,
    })
        .then((value) => print("Journal Edited"))
        .catchError((error) => print("Failed to edit journal: $error"));
  }

  Future<void> deleteJournal(String docId) {
    CollectionReference journals = Firestore.instance.collection('journal').document(this.uid).collection('journal');
    return journals
        .document(docId)
        .delete()
        .then((value) => print("Journal Deleted"))
        .catchError((error) => print("Failed to delete journal: $error"));
  }
}
