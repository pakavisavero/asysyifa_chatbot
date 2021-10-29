class Event {
  final String title;
  final String docId;
  final created;
  Event({this.title, this.docId, this.created});

  String toString() => this.title;
}
