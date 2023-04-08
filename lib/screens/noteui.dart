import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../services/dbhelper.dart';
import '../screens/desc.dart';

class NoteHomeUI extends StatefulWidget {
  const NoteHomeUI({super.key});

  @override
  State<NoteHomeUI> createState() => _NoteHomeUIState();
}

class _NoteHomeUIState extends State<NoteHomeUI> {
  ///////////////////////////insert database/////////////////////////////
  insertdatabase(tittle, description) {
    NoteDbHelper.instance.insert({
      NoteDbHelper.coltittle: tittle,
      NoteDbHelper.coldescription: description,
      NoteDbHelper.coldate: DateTime.now().toString(),
    });
  }

  updatedatabase(snap, index, tittle, description) {
    NoteDbHelper.instance.update({
      NoteDbHelper.colid: snap.data![index][NoteDbHelper.colid],
      NoteDbHelper.coltittle: tittle,
      NoteDbHelper.coldescription: description,
      NoteDbHelper.coldate: DateTime.now().toString(),
    });
  }
  

  deletedatabase(snap, index) {
    NoteDbHelper.instance.delete(snap.data![index][NoteDbHelper.colid]);
    NoteDbHelper.instance.queryAll();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.07,
          title: const Text('Note App')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: FutureBuilder(
            future: NoteDbHelper.instance.queryAll(),
            builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snap) {
              
              if (snap.hasData) {
                return ListView.builder(
                  itemCount: snap.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return DescriptionNote(
                                    tittle: snap.data![index]
                                        [NoteDbHelper.coltittle],
                                    description: snap.data![index]
                                        [NoteDbHelper.coldescription]);
                              },
                            ));

                            //
                          },
                         
                             
                          title:
                              Text(snap.data![index][NoteDbHelper.coltittle]),
                          subtitle: Row(
                            children: [
                              IconButton(onPressed: () async{
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return 
                                    AlertDialog(actions:[Column(
                                    children: [
                                      const Text('Are You Sure! Do you want to delete it',style: TextStyle(color: Colors.red),textAlign: TextAlign.center,)
                                      ,
                                      TextButton(onPressed: (){deletedatabase(snap, index);
                                      Navigator.pop(context);}, child: const Text('delete',style: TextStyle(color: Colors.red),)),
                                      TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Cancel'))
                                    ],
                                  )],);
                                    
                                  },
                                 
                                );
                                
                                
                              }, icon: const Icon(Icons.delete_forever,color: Colors.red,)),
                              IconButton(onPressed: (){showDialog(
                                  context: context,
                                  builder: (context) {
                                    var tittle = '';
                                    var description = '';
                                    return AlertDialog(
                                      title: const Text('Edit Note'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            onChanged: (value) {
                                              tittle = value;
                                            },
                                            decoration: InputDecoration(
                                                hintText: snap.data![index]
                                                    [NoteDbHelper.coltittle]),
                                          ),
                                          TextField(
                                              onChanged: (value) {
                                                description = value;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: snap.data![index][
                                                      NoteDbHelper
                                                          .coldescription])),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              updatedatabase(snap, index,
                                                  tittle, description);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Save'))
                                      ],
                                    );
                                  },
                                );
                            }, icon: const Icon(Icons.edit,color:Colors.blueAccent ,))
                            ],
                          ),
                          trailing: Text(snap.data![index][NoteDbHelper.coldate]
                              .toString()
                              .substring(0, 10)),
                        ),
                      
                    );
                  },
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(),
                    );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              var tittle = '';
              var description = '';
              return AlertDialog(
                title: const Text('Add Note'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                        onChanged: (value) {
                          tittle = value;
                        },
                        decoration: const InputDecoration(hintText: 'Title')),
                    TextField(
                        onChanged: (value) {
                          description = value;
                        },
                        decoration:
                            const InputDecoration(hintText: 'Description')),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                      
                  TextButton(
                      onPressed: () {
                        insertdatabase(tittle, description);
                        Navigator.pop(context);
                      },
                      child: const Text('Save'))
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
