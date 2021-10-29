import 'package:assyifa_chatbot/models/event.dart';
import 'package:assyifa_chatbot/services/database.dart';
import 'package:assyifa_chatbot/shared/loading.dart';
import 'package:assyifa_chatbot/views/screens/timeline/emoticon/detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Emoticon extends StatefulWidget {
  @override
  _EmoticonState createState() => _EmoticonState();
}

class _EmoticonState extends State<Emoticon> {
  bool isFirst = false;
  bool _isLoading = false;
  String _uid;
  final _currentAuth = FirebaseAuth.instance;

  Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  void setCurrentUserData() async {
    await _currentAuth.currentUser().then((value) {
      setState(() {
        _uid = value.uid;
      });
    });
  }

  @override
  void initState() {
    setCurrentUserData();
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _emoticonStream = Firestore.instance
        .collection('emoticon')
        .document(this._uid)
        .collection('emoticon')
        .orderBy('created_at', descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _emoticonStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('error');
          _isLoading = false;
          return Text('Something went wrong');
        }

        if (!snapshot.hasData)
          _isLoading = true;
        else {
          List<Event> tempList = [];

          for (int i = 0; i < snapshot.data.documents.length; i++) {
            final DocumentSnapshot document = snapshot.data.documents[i];
            tempList.add(
              Event(
                docId: document.documentID.toString(),
                title: document['title'],
                created: document['created_at'],
              ),
            );
          }

          selectedEvents[selectedDay] = tempList;

          _isLoading = false;
          isFirst = true;
        }

        return _isLoading
            ? Loading()
            : Scaffold(
                appBar: AppBar(
                  title: Text("Emoticon"),
                  centerTitle: true,
                  actions: [
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Detail();
                      })),
                      child: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(Icons.more),
                      ),
                    ),
                  ],
                ),
                body: ListView(
                  children: [
                    TableCalendar(
                      focusedDay: selectedDay,
                      firstDay: DateTime(1990),
                      lastDay: DateTime(2050),
                      calendarFormat: format,
                      onFormatChanged: (CalendarFormat _format) {
                        setState(() {
                          format = _format;
                        });
                      },
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      daysOfWeekVisible: true,

                      //Day Changed
                      onDaySelected: (DateTime selectDay, DateTime focusDay) {
                        // setState(() {
                        //   selectedDay = selectDay;
                        //   focusedDay = focusDay;
                        // });
                        // print(selectedDay);
                        // print(focusedDay);
                      },

                      selectedDayPredicate: (DateTime date) {
                        return isSameDay(selectedDay, date);
                      },

                      eventLoader: _getEventsfromDay,

                      //To style the Calendar
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: true,
                        selectedDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        selectedTextStyle: TextStyle(color: Colors.white),
                        todayDecoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          shape: BoxShape.rectangle,
                        ),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        weekendDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        formatButtonShowsNext: false,
                        formatButtonDecoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        formatButtonTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ..._getEventsfromDay(selectedDay)
                        .map((Event event) => event != null
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: Colors.blue[100],
                                        child: ListTile(
                                          title: Text(
                                            event.title,
                                          ),
                                          trailing: GestureDetector(
                                            onTap: () async {
                                              await DatabaseService(uid: _uid)
                                                  .deleteEmoticon(event.docId);
                                            },
                                            child: Icon(
                                              Icons.close,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox()),
                  ],
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Add Event"),
                      content: TextFormField(
                        controller: _eventController,
                      ),
                      actions: [
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                            print("SELECTED DAY :" +
                                selectedDay.runtimeType.toString());
                            print("FOCUSED DAY" +
                                focusedDay.runtimeType.toString());
                          },
                        ),
                        TextButton(
                          child: Text("Ok"),
                          onPressed: () async {
                            if (_eventController.text.isEmpty) {
                            } else {
                              Event calendarEmoticon = Event(
                                title: _eventController.text,
                                created: selectedDay,
                              );

                              await DatabaseService(uid: this._uid)
                                  .addEmoticon(calendarEmoticon);
                            }

                            print(selectedEvents);
                            Navigator.pop(context);
                            _eventController.clear();
                            setState(() {});
                            return;
                          },
                        ),
                      ],
                    ),
                  ),
                  label: Text("Add Event"),
                  icon: Icon(Icons.add),
                ),
              );
      },
    );
  }
}
