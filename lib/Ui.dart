import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'DBHelper.dart';
class Ui extends StatefulWidget {
  const Ui({Key? key}) : super(key: key);

  @override
  State<Ui> createState() => _UiState();
}

class _UiState extends State<Ui> {
  bool boolinsert =false;
  TextEditingController nameController= TextEditingController();
  TextEditingController gmailController= TextEditingController();
  TextEditingController cityController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String,dynamic>>>(
        future: DBHelper.instance.fetchData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return CircularProgressIndicator();
          }else{
            return SingleChildScrollView(
              child: Row(children: [
                for(int index=0;index<snapshot.data!.length;index++)
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(children: [
                      Text(snapshot.data![index]['name']),
                      Text(snapshot.data![index]['email']),
                      Text(snapshot.data![index]['city']),
                      ElevatedButton(onPressed: () {
                        int id =snapshot.data![index]['id'];
                        TextEditingController _nameController =TextEditingController();
                        TextEditingController _gmailController =TextEditingController();
                        TextEditingController _cityController =TextEditingController();
                        AlertDialog(
                          title: Text('Update'),
                          actions: [
                            TextField(controller:_nameController ,decoration: InputDecoration(hintText: 'name'),),
                            TextField(controller: _gmailController,decoration: InputDecoration(hintText: 'gmail'),),
                            TextField(controller: _cityController,decoration: InputDecoration(hintText: 'city'),),
                            ElevatedButton(onPressed: () {
                              String bname=_nameController.text.trim();
                              String bemail=_gmailController.text.trim();
                              String bcity=_cityController.text.trim();
                              if(bname!=''||bemail!=''||bcity!=''){
                                Map<String,dynamic> row ={'id':id,'name':bname,'email':bemail,'city':bcity};
                                DBHelper.instance.updateData(row);
                              }
                            }, child: Text('UPDATE'))
                          ],
                        );
                        }, child: Text('Update')),
                      ElevatedButton(onPressed: () {
                        int id =snapshot.data![index]['id'];
                        DBHelper.instance.deleteData(id);
                        }, child: Text('Delete'))
                    ]
                    ),
                  ),SizedBox(height: 10,),
              ]),
            );
          }
        },
      ),
      floatingActionButton: IconButton(onPressed: () {
        
      },icon: Icon(Icons.add,color: Colors.red,)),
      bottomSheet: Visibility(
        visible: boolinsert,
        child: Container(
          margin: EdgeInsets.all(20),
        height: 300,
        child: Column(
          children: [
            TextField(controller:nameController ,decoration: InputDecoration(hintText: 'name'),),
            TextField(controller: gmailController,decoration: InputDecoration(hintText: 'gmail'),),
            TextField(controller: cityController,decoration: InputDecoration(hintText: 'city'),),
            ElevatedButton(onPressed: () {
              String name= nameController.text.trim();
              String email= nameController.text.trim();
              String city= nameController.text.trim();
              Map<String,dynamic> row ={'name':name,'email':email,'city':city};
              if(name!=''||email!=''||city!=''){
                DBHelper.instance.insertData(row);
            setState(() {
              boolinsert=false;
            });
              }
            }, child: Text('INSERT'))
          ],
        ),
        ),
      ),
    );
  }
}
