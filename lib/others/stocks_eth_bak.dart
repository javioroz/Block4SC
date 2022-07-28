import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/eth.dart';

class Stocks extends ConsumerStatefulWidget {
  const Stocks({Key? key}) : super(key: key);

  @override
  _StocksState createState() => _StocksState();
}

class _StocksState extends ConsumerState<Stocks> {
  final TextEditingController _dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.watch(ethUtilsProviders);
    final ethUtils = ref.watch(ethUtilsProviders.notifier);

    final listTiles = <Widget>[
      const ListTile(
        title: Text('Here you can view and edit stock data:'),
      ),
      const Divider(), //----------------------------------------------------

      ListTile(
        // title + create stock button
        leading: const Icon(Icons.add_circle),
        title: const Text('Create new stock'),
        trailing: ElevatedButton(
            child: const Text('create'),
            onPressed: () {
              if (_dataController.text.isEmpty) return;
              ethUtils.setData(_dataController.text);
              _dataController.clear();
            }),
      ),

      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
        leading: const Icon(Icons.abc),
        subtitle: TextField(
          controller: _dataController,
          maxLines: 1,
          decoration: const InputDecoration(hintText: 'Enter material name'),
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
      const Divider(), //----------------------------------------------------

      const ListTile(
        leading: Icon(Icons.remove_circle),
        title: Text('Delete stock'),
        trailing: ElevatedButton(onPressed: null, child: Text('delete')),
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
        leading: Icon(Icons.remove_red_eye),
        title: Text('View list of all materials'),
        trailing: ElevatedButton(onPressed: null, child: Text('show')),
      ),
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
        leading: const Icon(Icons.arrow_forward),
        //subtitle: Text('resultAllMaterials'),
        subtitle: Text(ethUtils.deployedData!),
      ),
      const Divider(),
    ];
    // Directly returning a list of widgets is not common practice.
    // People usually use ListView.builder, c.f. "ListView.builder" example.
    // Here we mainly demostrate ListTile.
    return Scaffold(
      body: Container(
        child: ethUtils.isLoading
            ? const CircularProgressIndicator()
            : ListView(children: listTiles),
      ),
    );
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
