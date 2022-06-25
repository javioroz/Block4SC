import 'package:flutter/material.dart';

class Containers extends StatelessWidget {
  const Containers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _showButtonPressed() => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('button pressed'),
            duration: Duration(milliseconds: 500),
          ),
        );
    final listTiles = <Widget>[
      const ListTile(
        title: Text('Here you can view and edit container data:'),
      ),
      const Divider(), //----------------------------------------------------
      const ListTile(
        leading: Icon(Icons.add_circle),
        title: Text('Set Container Data'),
        trailing: ElevatedButton(onPressed: null, child: Text('create')),
      ),
      const ListTile(
        leading: Icon(Icons.numbers),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter container ID'),
        ),
      ),
      const ListTile(
        leading: Icon(Icons.abc),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter material name'),
        ),
      ),
      const ListTile(
        leading: Icon(Icons.numbers),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter quantity'),
        ),
      ),
      const ListTile(
        leading: Icon(Icons.abc),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter origin location'),
        ),
      ),
      const ListTile(
        leading: Icon(Icons.abc),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter destination location'),
        ),
      ),
      const Divider(), //----------------------------------------------------
      const ListTile(
        leading: Icon(Icons.remove_red_eye),
        title: Text('Get Container Data'),
        trailing: ElevatedButton(onPressed: null, child: Text('show')),
      ),
      const ListTile(
        leading: Icon(Icons.abc),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter Container ID'),
        ),
      ),
      const ListTile(
        leading: Icon(Icons.arrow_forward),
        subtitle: Text('Result'),
      ),
      const Divider(), //----------------------------------------------------
      const ListTile(
        leading: Icon(Icons.remove_red_eye),
        title: Text('View All Container IDs'),
        subtitle: Text('It shows the list of all materials'),
        trailing: ElevatedButton(onPressed: null, child: Text('show')),
      ),
      const ListTile(
        leading: Icon(Icons.arrow_forward),
        subtitle: Text('Result'),
      ),
      const Divider(),
    ];
    // Directly returning a list of widgets is not common practice.
    // People usually use ListView.builder, c.f. "ListView.builder" example.
    // Here we mainly demostrate ListTile.
    return ListView(children: listTiles);
  }
}
/*
        Column(children: <Widget>[
          TextField(
            maxLines: 1,
            decoration: InputDecoration(hintText: 'Enter material name'),
          ),
          TextField(
            maxLines: 1,
            decoration: InputDecoration(hintText: 'Enter material name'),
          ),
         ],
        ), 
        ),*/