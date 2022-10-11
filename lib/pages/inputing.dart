import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:accounting/services/accounting_data.dart';
import 'package:path/path.dart';


class Inputing extends StatefulWidget {
  const Inputing({ Key? key }) : super(key: key);

  @override
  _InputingState createState() => _InputingState();
}

class _InputingState extends State<Inputing> {
  bool inputValid=true;
  @override
  void initState() {
    super.initState();



  }
  final GlobalKey<ScaffoldState> snacckbar =new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController name = new TextEditingController();
    TextEditingController price = new TextEditingController();
    TextEditingController count = new TextEditingController();
    return MaterialApp(
     // key: snacckbar,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: snacckbar,
      appBar: AppBar(
        centerTitle: true,
        title: Text("برجاء ادخال البيانات",
        textAlign: TextAlign.right,)
        ),
        body: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(margin: EdgeInsets.all(20),
            child: TextField(
              controller: name,
              decoration: InputDecoration(
                hintText: 'أدخل أسم'
              ),
            )),
            Container(margin: EdgeInsets.all(20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: price,
                  decoration: InputDecoration(
                      hintText: 'أدخل السعر'
                  ),
                )),
            Container(margin: EdgeInsets.all(20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: count,
                  decoration: InputDecoration(


                      hintText: 'أدخل العدد'
                  ),

                  onChanged: (String count){
                    final Int = double.tryParse(count);
                    if(Int==null){
                      inputValid=false;

                    }
                    else{

                    }
                  },
                )),
            Container(padding: EdgeInsets.all(10),color: Colors.indigo,
              child: TextButton(onPressed: ()async{
                if(price.text.isEmpty){
                  price.text='0';
                }
                if(count.text.isEmpty){
                  count.text='1';
                }


              Database database=await openDatabase(join(await getDatabasesPath(),'demo.db'));
              database.rawQuery("INSERT INTO expenses_data (name, price ,quantity, total) VALUES('${name.text}',${double.parse(price.text)},${double.parse(count.text)},${double.parse(price.text)}*${double.parse(count.text)})");
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
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   String path=join(await getDatabasesPath(),'test.db');
//   final database = openDatabase(
//     path,
//     onCreate: (db, version){
//       return db.execute('CREATE TABLE data(name TEXT)');
//     },
//     version: 1
//   );
//   final database2 = openDatabase(
//     path, onOpen: (database){return database.execute('CREATE TABLE data(name TEXT)');}
//   );
// }
