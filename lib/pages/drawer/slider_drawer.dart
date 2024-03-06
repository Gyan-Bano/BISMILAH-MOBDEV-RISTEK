import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/profile/profile_form.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  // icons
  final List<IconData> icons = [
    CupertinoIcons.person_fill,
  ];

  List<String> texts = [
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(3),
              width: double.infinity,
              // height: 300,
              child: ListView.builder(
                  itemCount: icons.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        if (index == 0) { // Assuming 0 is the index for Profile
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ProfileForm(backgroundColor: Theme.of(context).primaryColor,),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var begin = Offset(-1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 10),
                        child: ListTile(
                          leading: Icon(
                            icons[index],
                            color: Colors.white,
                            size: 30,
                          ),
                          title: Text(
                            texts[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
