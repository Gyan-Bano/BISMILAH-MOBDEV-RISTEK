import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class ProfileForm extends StatelessWidget {
  final Color backgroundColor;

  ProfileForm({required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white, size: 40,),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/Gyan.png'),
              ),
              SizedBox(height: 20),
              Text(
                'Gyanamurti Adhikara Bano',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Gyan',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'About Me',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'I’m Gyanamurti Adhikara Bano, an Information Systems student at the University of Indonesia. Specializing in Python, Java, and Flutter, I’ve developed a strong foundation in mobile development. My experience with Django has also enhanced my web development skills. Aspiring to be a Mobile Developer, I’m eager to apply my knowledge and passion to create innovative mobile solutions.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hobbies',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Learning New Things, Playing Guitar, and Swimming',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Social Media',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.linkedin, color: Colors.white),
                    onPressed: () {
                      launchUrl(Uri.parse('https://www.linkedin.com/in/gyanamurti-adhikara-bano-3a3471248/'));
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.github, color: Colors.white),
                    onPressed: () {
                      launchUrl(Uri.parse('https://github.com/Gyan-Bano'));
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.instagram, color: Colors.white),
                    onPressed: () {
                      launchUrl(Uri.parse('https://www.instagram.com/gyan.bano/'));
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
