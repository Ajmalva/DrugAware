import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

import 'Report.dart';
import 'chat.dart';
import 'createPost.dart';
import 'postScreen.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final _pageController = PageController(initialPage: 1);

  int maxCount = 3;

  /// widget list
  final List<Widget> bottomBarPages = [
    StoreLocationScreen(),
    PostScreen(),
    chat(), // effectsScreen(),
    // const Page5(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              pageController: _pageController,
              color: Color.fromARGB(255, 33, 33, 33),
              showLabel: false,
              notchColor: Colors.white,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.report,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.report_off_outlined,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 1',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 2',
                ),

                ///svg example
                BottomBarItem(
                  // inActiveItem: SvgPicture.asset(
                  //   'assets/search_icon.svg',
                  //   color: Colors.blueGrey,
                  // ),
                  // activeItem: SvgPicture.asset(
                  //   'assets/search_icon.svg',
                  //   color: Colors.white,
                  // ),
                  inActiveItem: Icon(
                    Icons.chat,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.chat,
                    color: Colors.yellow,
                  ),
                  itemLabel: 'Page 3',
                ),
                // BottomBarItem(
                //   inActiveItem: Icon(
                //     Icons.settings,
                //     color: Colors.blueGrey,
                //   ),
                //   activeItem: Icon(
                //     Icons.settings,
                //     color: Colors.pink,
                //   ),
                //   itemLabel: 'Page 4',
                // ),
                // BottomBarItem(
                //   inActiveItem: Icon(
                //     Icons.person,
                //     color: Colors.blueGrey,
                //   ),
                //   activeItem: Icon(
                //     Icons.person,
                //     color: Colors.yellow,
                //   ),
                //   itemLabel: 'Page 5',
                // ),
              ],
              onTap: (index) {
                /// control your animation using page controller
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              },
            )
          : null,
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightGreenAccent,
        child: const Center(child: Text('Page 4')));
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromARGB(255, 62, 30, 157),
        child: const Center(child: Text('Page 2')));
  }
}
