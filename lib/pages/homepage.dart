import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Homepage extends StatefulWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    void a () async{
      var databasesPath =  await getDatabasesPath();
      String path = join(databasesPath, 'demo.db');
      Database database= await openDatabase(path, version:1,
          onCreate: (database,int version) async{
            await database.execute('''CREATE TABLE expenses_data (name TEXT DEFAULT ' ', quantity FLOAT DEFAULT 1, price FLOAT DEFAULT 0
,total FLOAT DEFAULT 0, date_time TEXT DEFAULT (datetime('now','localtime')))''');

    });
      //database.rawQuery('DROP TABLE expenses_data');
      database.rawQuery('''CREATE TABLE IF NOT EXISTS gains_data(name TEXT DEFAULT ' ',gains DOUBLE DEFAULT 0
            , date_time TEXT DEFAULT (datetime('now','localtime')))''');
      database.rawQuery('''CREATE TABLE IF NOT EXISTS expenses_data (name TEXT DEFAULT ' ', quantity FLOAT DEFAULT 1, price FLOAT DEFAULT 0
,total FLOAT DEFAULT 0, date_time TEXT DEFAULT (datetime('now','localtime')))''');





    }


    a();
  }
  Future<String> tot_gains () async{
    Database database=await openDatabase(join(await getDatabasesPath(),'demo.db'));



    var x = await database.rawQuery("SELECT sum(gains) FROM gains_data");
    print(x);
    return x[0]['sum(gains)'].toString();
  }
  Future<String> tot_paid () async{
    Database database=await openDatabase(join(await getDatabasesPath(),'demo.db'));



    var x = await database.rawQuery("SELECT sum(total) FROM expenses_data");
    print(x);
    return x[0]['sum(total)'].toString();
  }
  void running_queries() async{
    Database database=await openDatabase(join(await getDatabasesPath(),'demo.db'));
    //database.rawQuery( '''INSERT INTO expenses_data (date_time) VALUES(datetime('2069-06-09 22:00:01'))''');

    print('done');
  }

  double total_gains =0;
  double total_paid=0;
  double total=0;
  @override

  Widget build(BuildContext context) {
tot_gains().then((value) => total_gains=double.parse(value));
tot_paid().then((value) => total_paid=double.parse(value));
total=total_gains-total_paid;
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
        appBar: AppBar(
          title: Text('مرحب'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: TextButton(child: Text("ادخال"),onPressed:(){
                setState(() {
                  Navigator.pushNamed(context, '/inputing');

                });} ),
            ),
            TextButton(child: Text("قراءة"),onPressed:(){
              setState(() {
                Navigator.pushNamed(context, '/outputing');

              });} ),
            TextButton(child: Text("ادخال الايرادات"),onPressed:(){
              setState(() {
                Navigator.pushNamed(context, '/inputing_gains');

              });} ),
            TextButton(child: Text("قراءة الايرادات"),onPressed:(){
              setState(() {
                Navigator.pushNamed(context, '/outputing_gains');

              });} ),
            Text("المتبقي: ${total}  ")

          ],),
      ),) ,

    );
  }
}