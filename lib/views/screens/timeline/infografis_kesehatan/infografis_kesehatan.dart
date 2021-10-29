import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InfografisKesehatan extends StatefulWidget {
  static String routeName = "/infografis_kesehatan";

  @override
  _InfografisKesehatanState createState() => _InfografisKesehatanState();
}

class _InfografisKesehatanState extends State<InfografisKesehatan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5f5ff),
        appBar: AppBar(
          title: Text('Infografis Kesehatan'),
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xFF1032AF), Color(0xff7b98ff)])),
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          'assets/images/infografis_kesehatan/depres.png',
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          height: 220,
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Tahukah Kamu?",
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Depresi merupakan penyakit yang ditandai dengan rasa sedih dan kehilangan minat tergadap segala hal. ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 225,
                ),
                statsCard("Depresi selama pandemi", '244,957', 10, 2),
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 225,
                ),
                statsCard("DEPRESI SELAMA PANDEMI", '244,957', 10, 2),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 25, 25, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Pencegahan',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      requirementCard(
                          "assets/images/infografis_kesehatan/Quran.png",
                          "Perbanyak ibadah"),
                      requirementCard(
                          "assets/images/infografis_kesehatan/olahraga.png",
                          "Jaga pola hidup sehat"),
                      requirementCard(
                          "assets/images/infografis_kesehatan/Komunikasi.png",
                          "Komunikasi dengan orang terdekat"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

Widget pageelements(String img, String label) {
  return Container(
    margin: EdgeInsets.all(4),
    child: Column(
      children: <Widget>[
        Container(
          child: Image.asset(img),
        ),
        SizedBox(
          height: 4,
        ),
        Text(label)
      ],
    ),
  );
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldclipper) {
    return false;
  }
}

Widget statsCard(String title, String count, int p1, int p2) {
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 17, 30, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF7777FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 190,
                  width: 300,
                  child: Image.asset(
                      'assets/images/infografis_kesehatan/Graph1.png'),
                )
              ],
            ),
          ],
        ),
      ));
}

Widget requirementCard(String img, String label) {
  return Padding(
    padding: EdgeInsets.all(1.0),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(right: 20),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            Container(
              child: Image.asset(img),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              label,
              style: TextStyle(color: Color(0xFF7777FF), fontSize: 18),
            )
          ],
        ),
      ),
    ),
  );
}
