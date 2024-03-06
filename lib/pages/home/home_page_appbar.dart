import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:todo_app/main.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.drawerKey});

  final GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController animatecontroller;
  bool isDrawerOpen = false;

  @override
  void initState() {
    animatecontroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    animatecontroller.dispose();
    super.dispose();
  }

  // on toggle
  void onDrawerToggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        animatecontroller.forward();
        widget.drawerKey.currentState!.openSlider();
      } else {
        animatecontroller.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          // menu icon
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                  onPressed: onDrawerToggle,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: animatecontroller,
                    size: 40,
                  )),
            ),

            // trash icon
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                  onPressed: () {
                    // delete all
                    // base.isEmpty ? null :
                    BaseWidget.of(context).dataStore.box.clear();
                  },
                  icon: const Icon(
                    CupertinoIcons.trash_fill,
                    size: 40,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
