import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Invite extends StatefulWidget {
  @override
  _InviteState createState() => _InviteState();
}

class _InviteState extends State<Invite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Undang Teman'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Cari Kontak",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 30,
              thickness: 2,
            ),
            Row(
              children: [
                Icon(
                  Icons.share_outlined,
                  color: Colors.blue.shade900,
                ),
                SizedBox(
                  height: 20,
                  width: 10,
                ),
                Text(
                  "Bagikan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 30,
              thickness: 0,
            ),
            Row(
              children: [
                Icon(
                  Icons.person_add_alt_1,
                  color: Colors.blue.shade900,
                ),
                SizedBox(
                  height: 20,
                  width: 10,
                ),
                Text(
                  "Arya",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10,
              width: 30,
            ),
            Text(
              "081259862465",
              style: TextStyle(fontSize: 15, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }
}
