import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class outputing_gains extends StatefulWidget {
  const outputing_gains({Key? key}) : super(key: key);

  @override
  _outputing_gainsState createState() => _outputing_gainsState();
}

class _outputing_gainsState extends State<outputing_gains> {
  List<Map> dataMap=[{'a':23},{'a':23},{'a':23}];
  Future<List<Map>> dblist () async{
    Database database=await openDatabase(join(await getDatabasesPath(),'demo.db'));

    List<Map> all = await database.rawQuery("SELECT * FROM gains_data ORDER BY DATETIME(date_time) DESC");


    return all;


  }

  @override
  double total=0;
  Widget build(BuildContext context) {
    dblist().then((value){setState(() {
      dataMap=value;

    });});
    return MaterialApp(

      home: Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(

          appBar: AppBar(
            title: Text("الاجمالي ${total}"),
            actions: [
              IconButton(color: Colors.white,onPressed: (){
                setState(() {
                  double placeholder =0;
                  dataMap.forEach((map) { placeholder=placeholder+map['gains'];});
                  total=placeholder;
                  print(total);
                });
              }, icon: Icon(Icons.add)),

            ],

          ),
          body: ListView.builder(
              itemCount: dataMap.length,
              itemBuilder: (context,index){

                return Slidable(

                  actionPane: SlidableScrollActionPane(),
                  actions: [

                    IconSlideAction(

                      caption: 'حذف',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: (){

                        Future<List<Map>> newDataMap() async{
                          Database database=await openDatabase(join(await getDatabasesPath(),'demo.db'));
                          await database.rawQuery("DELETE FROM gains_data WHERE date_time='${dataMap[index]['date_time']}'");
                          dataMap.remove(dataMap[index]);
                          return dataMap;}
                        setState(() {
                          newDataMap().then((value) => dataMap=value);

                        });
                      },
                    )
                  ],
                  child: Container(

                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: ListTile(

                      tileColor: Colors.white,
                      title: Text(dataMap[index]['name'].toString(),
                        style: TextStyle(fontSize: 25),)
                      ,
                      trailing: Text('مبلغ '+dataMap[index]['gains'].toString(),
                        style: TextStyle(fontSize: 25),),
                      subtitle: Text('في تاريخ '+dataMap[index]['date_time'].toString(),
                      ),
                      isThreeLine: false,

                    ),
                  ),
                );
              }),

        ),),
    );
  }
}
