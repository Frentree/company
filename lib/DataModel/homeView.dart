import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:companyplaylist/DataModel/work_model.dart';
import 'package:companyplaylist/DataModel/CRUD_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget{
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>{
  List<Work> work;

  @override
  Widget build(BuildContext context) {
    final workProvider = Provider.of<CRUDModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/setting_page');
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Center(child: Text('home'),),
      ),
      body: Container(
        child: StreamBuilder(
          stream: workProvider.fetchWorkAsStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasData){
              work = snapshot.data.documents.map((doc) => Work.fromMap(doc.data, doc.documentID)).toList();
              print(work.length);
              return ListView.builder(
                itemCount: work.length,
                itemBuilder: (buildContext, index){
                  return Container(
                    child: Text(
                      work.length.toString()
                    ),
                  );
                },
              );
            }
            else {
              return Text("hi");
            }
          },
        ),
      ),
    );
  }
}