import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:block4sc/utils/eth.dart';

class Containers extends StatelessWidget {
  const Containers({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //ref.watch(ethUtilsProviders);
    //final ethUtils = ref.watch(ethUtilsProviders.notifier);

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
        title: Text('Set container data'),
        trailing: ElevatedButton(onPressed: null, child: Text('create')),
      ),
      const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 60.0),
        leading: Icon(Icons.onetwothree),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter container ID'),
        ),
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
        leading: Icon(Icons.onetwothree),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter quantity'),
        ),
      ),
      const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 60.0),
        leading: Icon(Icons.abc),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter origin location'),
        ),
      ),
      const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 60.0),
        leading: Icon(Icons.abc),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter destination location'),
        ),
      ),
      const Divider(), //----------------------------------------------------
      const ListTile(
        leading: Icon(Icons.remove_red_eye),
        title: Text('Get container data'),
        trailing: ElevatedButton(onPressed: null, child: Text('show')),
      ),
      const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 60.0),
        leading: Icon(Icons.abc),
        subtitle: TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Enter Container ID'),
        ),
      ),
      const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 60.0),
        leading: Icon(Icons.arrow_forward),
        subtitle: Text('resultContainerData'), //resultContainerData
      ),
      const Divider(), //----------------------------------------------------
      const ListTile(
        leading: Icon(Icons.remove_red_eye),
        title: Text('View all container IDs'),
        trailing: ElevatedButton(onPressed: null, child: Text('show')),
      ),
      const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 60.0),
        leading: Icon(Icons.arrow_forward),
        subtitle: Text('resultAllContIDs'),
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