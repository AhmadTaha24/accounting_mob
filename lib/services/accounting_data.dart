import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Acc_data {
  final String name;
  Acc_data({
    required this.name
  });
 
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(),'test.db'),
    onCreate: (db, version){
      return db.execute('CREATE TABLE data(name TEXT)');
    },
    version: 1
  );
}
