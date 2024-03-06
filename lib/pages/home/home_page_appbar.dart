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

 // Function to show the confirmation dialog
 void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete all of your tasks?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                BaseWidget.of(context).dataStore.box.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
 }

 @override
 Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return SizedBox(
      width: double.infinity,
      height: 90,
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
                  if (base.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "There is no task to delete",
                          style: TextStyle(color: Colors.white),
                          ),
                        backgroundColor: Colors.black,
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  } else {
                    showConfirmationDialog(context);
                  }
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
