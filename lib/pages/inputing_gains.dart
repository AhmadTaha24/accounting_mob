import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class inputing_gains extends StatefulWidget {
  const inputing_gains({Key? key}) : super(key: key);

  @override
  _inputing_gainsState createState() => _inputing_gainsState();
}

class _inputing_gainsState extends State<inputing_gains> {
  bool inputValid=true;
  final GlobalKey<ScaffoldState> snacckbar =new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController name = new TextEditingController();
    TextEditingController price = new TextEditingController();

    return MaterialApp(
      // key: snacckbar,
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            key: snacckbar,
            appBar: AppBar(
                centerTitle: true,
                title: Text("برجاء ادخال بيانات الارادات",
                  textAlign: TextAlign.right,)
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(margin: EdgeInsets.all(20),
                    child: TextField(
                      controller: name,
                      decoration: InputDecoration(
                          hintText: 'ادخل الاسم(المكان او صفة)'
                      ),
                    )),
                Container(margin: EdgeInsets.all(20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: price,
                      decoration: InputDecoration(
                          hintText: 'أدخل المبلغ'
                      ),
                    )),

                Container(padding: EdgeInsets.all(10),color: Colors.indigo,
                    child: TextButton(onPressed: ()async{
                      if(price.text.isEmpty){
                        price.text='0';
                      }


                      Database database=await openDatabase(join(await getDatabasesPath(),'demo.db'));
                      database.rawQuery("INSERT INTO gains_data (name, gains,date_time) VALUES('${name.text}',${double.parse(price.text)},DATETIME('NOW','LOCALTIME'))");
                      print(name.text);

                      snacckbar.currentState!.showSnackBar(new SnackBar(content: Text('تم الحفظ'),
                        duration: Duration(seconds: 1) ,));
                    },child: Text('حفظ'),)),
              /*  TextButton(onPressed:(){
                  snacckbar.currentState!.showSnackBar(new SnackBar(content: Text('sad')));
                }, child: Text("sda")) */
              ],),

          )),
    );
  }
}
