
import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'pages/inputing.dart';
import 'pages/outputing.dart';
import 'pages/inputing_gains.dart';
import 'pages/outputing_gains.dart';



void main(){
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/' : (context) => Homepage(),
      '/inputing' : (context) => Inputing(),
      '/outputing' : (context) => Outputing(),
      '/inputing_gains':(context) => inputing_gains(),
      '/outputing_gains':(context) => outputing_gains()
    },
  ));
}