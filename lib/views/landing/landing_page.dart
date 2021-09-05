import 'package:assyifa_chatbot/shared/custom_button.dart';
import 'package:assyifa_chatbot/views/landing/slider.dart';
import 'package:assyifa_chatbot/views/login.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentPage = 0;
  PageController _controller = PageController();
  final Color _blue = Color(0xFF39A2DB);

  List<Widget> _pages = [
    SliderPage(
        title: 'Selamat Datang di As-Syifa',
        description:
        'As-Syifa adalah aplikasi mood tracker, jurnal, dan teman bercerita untuk kamu.',
        image: 'assets/landing1.png'),
    SliderPage(
        title: 'Layanan Kami',
        description:
        'Kami membantu orang-orang untuk mengatasi masalah kesehatan mental mereka.',
        image: 'assets/landing2.png'),
    SliderPage(
        title: 'Fitur Chat Bot',
        description:
        'Butuh teman untuk bercerita? Kamu bisa coba mengobrol dengan chat bot milik kami.',
        image: 'assets/landing3.png'),
  ];

  _onChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD0F3FC),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Stack(
          children: <Widget>[
            PageView.builder(
              scrollDirection: Axis.horizontal,
              onPageChanged: _onChanged,
              controller: _controller,
              itemCount: _pages.length,
              itemBuilder: (context, int index) {
                return _pages[index];
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(_pages.length, (int index) {
                      return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 10,
                          width: (index == _currentPage) ? 30 : 10,
                          margin:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: (index == _currentPage)
                                  ? _blue
                                  : _blue.withOpacity(0.5)));
                    })),
                SizedBox(height: 40),
                InkWell(
                  onTap: () {
                    _controller.nextPage(
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeInOutQuint);
                  },
                  child: CustomButton('Ayo Mulai', () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login()));
                  })
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
