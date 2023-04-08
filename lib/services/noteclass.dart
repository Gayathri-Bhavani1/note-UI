import 'package:flutter/material.dart';

class DescriptionNote extends StatefulWidget {
  var tittle;
  var description;

  DescriptionNote({required this.tittle, required this.description});

  @override
  State<DescriptionNote> createState() => _DescriptionNoteState();
}

class _DescriptionNoteState extends State<DescriptionNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Description'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.tittle.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 100,
                      child: Card(
                        child: ListTile(
                          title: Text(widget.tittle ?? ""),
                          //subtitle: Text(widget.description ?? ""),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
