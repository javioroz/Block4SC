import 'package:flutter/material.dart';

class Locations extends StatelessWidget {
  const Locations({Key? key}) : super(key: key);

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
        title: Text('Here you can view stock data in locations:'),
      ),
      const Divider(), //----------------------------------------------------
      const ListTile(
        leading: Icon(Icons.auto_awesome_mosaic),
        title: Text('View Materials in a Location'),
        trailing: ElevatedButton(onPressed: null, child: Text('show')),
      ),
      const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 60.0),
        leading: Icon(Icons.abc),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter material name'),
        ),
      ),
      const Divider(), //----------------------------------------------------
      const ListTile(
        leading: Icon(Icons.countertops),
        title: Text('View Quantity of a Materials in a Location'),
        subtitle: Text('Enter material name and quantity'),
        trailing: ElevatedButton(onPressed: null, child: Text('show')),
      ),
      const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 60.0),
        leading: Icon(Icons.abc),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter material name'),
        ),
      ),
      const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 60.0),
        leading: Icon(Icons.abc),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter location name'),
        ),
      ),
      const Divider(), //----------------------------------------------------
      const ListTile(
        leading: Icon(Icons.warehouse),
        title: Text('View All Locations'),
        subtitle: Text('It shows the list of all locations'),
        trailing: ElevatedButton(onPressed: null, child: Text('show')),
      ),
      const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 60.0),
        leading: Icon(Icons.arrow_forward),
        subtitle: Text('resultAllLocations'),
      ),
      const Divider(), //----------------------------------------------------
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