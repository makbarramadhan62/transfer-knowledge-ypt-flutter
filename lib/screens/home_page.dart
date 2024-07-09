import 'package:flutter/material.dart';
import 'package:starter_template_flutter/utils/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Text(
          "Code your UI here",
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.w500,
            color: primary,
          ),
        ),
      ),
    );
  }
}
