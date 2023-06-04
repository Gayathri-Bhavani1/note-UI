import 'package:flutter/material.dart';
import '../services/dbhelper.dart';
import '../screens/desc.dart';

class NoteHomeUI extends StatefulWidget {
  const NoteHomeUI({Key? key}) : super(key: key);

  @override
  _NoteHomeUIState createState() => _NoteHomeUIState();
}

class _NoteHomeUIState extends State<NoteHomeUI> {
  late Future<List<Map<String, dynamic>>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _fetchNotes(); // Fetch notes from the database
  }

  void _fetchNotes() {
    setState(() {
      _notesFuture = NoteDbHelper.instance.queryAll(); // Retrieve notes from the database
    });
  }

  void _insertDatabase(String title, String description) {
    NoteDbHelper.instance.insert({
      NoteDbHelper.coltittle: title,
      NoteDbHelper.coldescription: description,
      NoteDbHelper.coldate: DateTime.now().toString(),
    }).then((_) {
      _fetchNotes(); // Refresh notes after inserting a new one
    });
  }

  void _updateDatabase(Map<String, dynamic> note) {
    NoteDbHelper.instance.update(note).then((_) {
      _fetchNotes(); // Refresh notes after updating
    });
  }

  void _deleteDatabase(int id) {
    NoteDbHelper.instance.delete(id).then((_) {
      _fetchNotes(); // Refresh notes after deleting
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        title: const Text('Note App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _notesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error occurred while loading notes.'),
                );
              }

              final List<Map<String, dynamic>> notes = snapshot.data ?? [];

              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];

                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionNote(
                              tittle: note[NoteDbHelper.coltittle],
                              description: note[NoteDbHelper.coldescription],
                            ),
                          ),
                        );
                      },
                      title: Text(note[NoteDbHelper.coltittle]),
                      subtitle: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Are You Sure?'),
                                    content: const Text(
                                      'Do you want to delete it?',
                                      style: TextStyle(color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          _deleteDatabase(note[NoteDbHelper.colid]);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  String title = note[NoteDbHelper.coltittle];
                                  String description = note[NoteDbHelper.coldescription];

                                  return AlertDialog(
                                    title: const Text('Edit Note'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          onChanged: (value) {
                                            title = value;
                                          },
                                          decoration: InputDecoration(
                                            hintText: note[NoteDbHelper.coltittle],
                                          ),
                                        ),
                                        TextField(
                                          onChanged: (value) {
                                            description = value;
                                          },
                                          decoration: InputDecoration(
                                            hintText: note[NoteDbHelper.coldescription],
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final updatedNote = {
                                            NoteDbHelper.colid: note[NoteDbHelper.colid],
                                            NoteDbHelper.coltittle: title,
                                            NoteDbHelper.coldescription: description,
                                            NoteDbHelper.coldate: DateTime.now().toString(),
                                          };
                                          _updateDatabase(updatedNote);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        note[NoteDbHelper.coldate].toString().substring(0, 10),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String title = '';
              String description = '';

              return AlertDialog(
                title: const Text('Add Note'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        description = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _insertDatabase(title, description);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
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
