import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Outputing extends StatefulWidget {
  const Outputing({Key? key}) : super(key: key);

  @override
  _OutputingState createState() => _OutputingState();
}

class _OutputingState extends State<Outputing> {

  String txt = "dasf";
  List<Map> dataMap=[{'a':23},{'a':23},{'a':23}];
  Future<String> aa () async{
    Database database=await openDatabase(join(await getDatabasesPath(),'demo.db'));
    List<Map> list = await database.rawQuery("SELECT price FROM expenses_data WHERE name = 'noodles'");
    List<Map> all = await database.rawQuery("SELECT * FROM expenses_data");

    //print(list[0]['price']);
    return list[0]['price'].toString();


  }
  String query = "SELECT * FROM expenses_data WHERE DATE(date_time) = DATE('now','localtime') ORDER BY rowid ASC";
  String delete_query = "DELETE FROM expenses_data WHERE date_time='";

  Future<List<Map>> dblist () async{
    Database database=await openDatabase(join(await getDatabasesPath(),'demo.db'));
    List<Map> list = await database.rawQuery("SELECT price FROM expenses_data WHERE name = 'noodles'");
    List<Map> all = await database.rawQuery(query);


    return all;


  }


  @override
  void initState() {
      super.initState();
int x;
      aa().then((value){setState(() {
        txt=value;
        print('a');
        print(txt);

      }); });


  }

  @override
  double total=0;
  Widget build(BuildContext context) {

    dblist().then((value){setState(() {
      dataMap=value;

    });});


    //dataMap.forEach((map) { total=total+map['total'];});

//print(total);


    return MaterialApp(

      home: Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(

          appBar: AppBar(
            title: Text("الاجمالي ${total}"),
            actions: [
              IconButton(color: Colors.white,onPressed: (){
                setState(() {
                  double placeholder =0;
                  dataMap.forEach((map) { placeholder=placeholder+map['total'];});
                  total=placeholder;
                  print(total);
                });
              }, icon: Icon(Icons.add)),
              PopupMenuButton(
                  itemBuilder: (BuildContext context){
                    return[
                      PopupMenuItem(child: TextButton(child: Text('رتب حسب التاريخ'),
                      onPressed: (){setState(() {
                        query = "SELECT * FROM expenses_data WHERE DATE(date_time) ORDER BY datetime(date_time) DESC";
                      });},),


                      ),
                      PopupMenuItem(child: TextButton(child: Text('اخر 10 ايام'),
                        onPressed: (){setState(() {
                          query = '''SELECT * FROM expenses_data WHERE date_time > (SELECT DATETIME('NOW','-10 DAY'))
                          ORDER BY datetime(date_time) DESC''';
                        });},),


                      ),
                      PopupMenuItem(child: TextButton(child: Text('اختار تاريخ'),
                      onPressed: () async{
                        final initialDate = DateTime.now();
                        var chosen_date= await showDatePicker(context: context, initialDate: initialDate,
                            firstDate: DateTime(DateTime.now().year-5), lastDate: DateTime(DateTime.now().year+5));
                        List<String> date_time_list=chosen_date.toString().split(' ');
                        if(chosen_date==null){
                          chosen_date=initialDate;
                        }



                        query='''SELECT * FROM expenses_data WHERE DATE(date_time) = '${date_time_list[0]}' ''';
                        print(date_time_list[0]);
                      },)),
                      PopupMenuItem(child: TextButton(child: Text('اختار مدة'),
                        onPressed: () async{
                          final initialDate = DateTime.now();
                          var chosen_date_range= await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(DateTime.now().year-5),
                              lastDate: DateTime(DateTime.now().year+5));
                          List<String> all_ranges= chosen_date_range.toString().split(' ');
                          //all_ranges[0] is the start //all_ranges[3] is the end




                          query='''SELECT * FROM expenses_data WHERE DATE(date_time) BETWEEN '${all_ranges[0]}' AND '${all_ranges[3]}'  ''';
                          print(all_ranges[3]);
                        },)),
                     

                    ];

              })
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
                          await database.rawQuery("${delete_query}${dataMap[index]['date_time']}'");
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
                      , leading: Text('عدد '+dataMap[index]['quantity'].toString(),
                    style: TextStyle(fontSize: 20),),
                      trailing: Text('بسعر '+dataMap[index]['price'].toString(),
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
