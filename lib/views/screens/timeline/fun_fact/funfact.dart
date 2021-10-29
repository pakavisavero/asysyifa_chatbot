import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'funfact_data.dart';

class FunFact extends StatefulWidget {
  static String routeName = "/funfact";

  @override
  _FunFactState createState() => _FunFactState();
}

class _FunFactState extends State<FunFact> {
  int selectedIndex = 0;
  List<String> categories = ['Teratas', 'Islami', 'Kesehatan Mental'];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar: AppBar(
          title: Text('Fun Fact'),
          actions: [
            Icon(
              Icons.notifications_none_rounded,
              size: 25,
            ),
            SizedBox(width: 20),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 45,
                child: ListView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = i;
                                  });
                                },
                                child: Text(
                                  categories[i],
                                  style: GoogleFonts.roboto(
                                      color: i == selectedIndex
                                          ? Color(0xFF2834CF)
                                          : Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: i == selectedIndex
                                        ? Color(0xFF2834CF)
                                        : Color(0xfff5f5f5)),
                              )
                            ],
                          ),
                        )),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Container(
                child: ListView.builder(
                    itemCount: plants.length,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, i) => list(context, i)),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

Widget list(context, i) {
  Size size = MediaQuery.of(context).size;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Material(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      child: Container(
        height: 185,
        width: size.width - 50,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, top: 10, bottom: 10, right: 5),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xffe8f6ee)),
                child: Image.network(
                  plants[i].imgUrl,
                  width: 130,
                ),
              ),
            ),
            Container(
              width: size.width / 2.2,
              height: 150,
              child: Text(
                plants[i].desc,
                softWrap: true,
                style: GoogleFonts.roboto(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
