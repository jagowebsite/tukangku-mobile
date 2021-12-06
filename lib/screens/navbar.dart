import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/auth_bloc/auth_bloc.dart';
import 'package:tukangku/screens/account/account.dart';
import 'package:tukangku/screens/design/design.dart';
import 'package:tukangku/screens/home/dashboard.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 1;

  late PageController _pageController;

  // static const List<Widget> _widgetOptions = <Widget>[
  //   Dashboard(),
  //   Design(),
  //   Account(),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess || state is UnAuthorized) {
          // Navigator.of(context).popAndPushNamed('/');
          // Navigator.pushAndRemoveUntil<void>(
          //   context,
          //   MaterialPageRoute<void>(
          //       builder: (BuildContext context) => MyHomePage()),
          //   ModalRoute.withName('/'),
          // );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        // body: Center(
        //   child: _widgetOptions.elementAt(_selectedIndex),
        // ),
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            children: <Widget>[
              Dashboard(),
              Design(),
              Account(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.black26,
          selectedFontSize: 12,
          iconSize: 27,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Desain',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box_rounded),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orangeAccent.shade700,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
