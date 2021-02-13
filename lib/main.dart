import 'package:flutter/material.dart';
import 'file:///C:/Users/hamos/AndroidStudioProjects/shopini_app/lib/auth_screen.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.blueAccent,
            fontFamily: 'Lato'
        ),
        home: AuthScreen(),
   );
  }
}
