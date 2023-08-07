
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/utils.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 500;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child: Container(
        // androidlarge1BBm (1:11)
        width: double.infinity,
        height: 750*fem,
        decoration: BoxDecoration (
          color: Color(0xffadadad),
          borderRadius: BorderRadius.circular(3*fem),
        ),
        child: Stack(
          children: [
            Positioned(
              // ellipse1nUP (1:19)
              left: 0*fem,
              top: 49*fem,
              child: Align(
                child: SizedBox(
                  width: 936.08*fem,
                  height: 652.35*fem,
                  child: Image.asset(
                    'assets/page-1/images/ellipse-1.png',
                    width: 936.08*fem,
                    height: 652.35*fem,
                  ),
                ),
              ),
            ),
            Positioned(
              // rectangle1zaT (1:12)
              left: 79*fem,
              top: 288*fem,
              child: Align(
                child: SizedBox(
                  width: 323*fem,
                  height: 43*fem,
                  child: Container(
                    decoration: BoxDecoration (
                      borderRadius: BorderRadius.circular(10*fem),
                      color: Color(0xffd9d9d9),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // rectangle3Ezb (1:14)
              left: 141*fem,
              top: 480*fem,
              child: Align(
                child: SizedBox(
                  width: 200*fem,
                  height: 43*fem,
                  child: Container(
                    decoration: BoxDecoration (
                      borderRadius: BorderRadius.circular(10*fem),
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // rectangle272o (1:13)
              left: 79*fem,
              top: 387*fem,
              child: Align(
                child: SizedBox(
                  width: 323*fem,
                  height: 43*fem,
                  child: Container(
                    decoration: BoxDecoration (
                      borderRadius: BorderRadius.circular(10*fem),
                      color: Color(0xffd9d9d9),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // loginawy (1:15)
              left: 215*fem,
              top: 490*fem,
              child: Align(
                child: SizedBox(
                  width: 52*fem,
                  height: 25*fem,
                  child: Text(
                    'Login',
                    style: SafeGoogleFont (
                      'Inter',
                      fontSize: 20*ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125*ffem/fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // teladeloginn2T (1:16)
              left: 146*fem,
              top: 145*fem,
              child: Align(
                child: SizedBox(
                  width: 190*fem,
                  height: 37*fem,
                  child: Text(
                    'Tela de Login',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont (
                      'Inter',
                      fontSize: 30*ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125*ffem/fem,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // nomecompleto1fu (1:17)
              left: 85*fem,
              top: 255*fem,
              child: Align(
                child: SizedBox(
                  width: 135*fem,
                  height: 21*fem,
                  child: Text(
                    'Nome Completo:',
                    style: SafeGoogleFont (
                      'Inter',
                      fontSize: 17*ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125*ffem/fem,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // senha4PH (1:18)
              left: 85*fem,
              top: 354*fem,
              child: Align(
                child: SizedBox(
                  width: 56*fem,
                  height: 21*fem,
                  child: Text(
                    'Senha:',
                    style: SafeGoogleFont (
                      'Inter',
                      fontSize: 17*ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125*ffem/fem,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}