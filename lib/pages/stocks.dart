import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/eth.dart';

class Stocks extends ConsumerStatefulWidget {
  const Stocks({Key? key}) : super(key: key);

  @override
  _StocksState createState() => _StocksState();
}

class _StocksState extends ConsumerState<Stocks> {
  final TextEditingController _createMatNameController =
      TextEditingController();
  final TextEditingController _createMatQtyController = TextEditingController();
  final TextEditingController _deleteMatNameController =
      TextEditingController();
  final TextEditingController _deleteLocNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.watch(ethUtilsProviders);
    final ethUtils = ref.watch(ethUtilsProviders.notifier);

    return Scaffold(
      body: Container(
        child: ethUtils.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(children: <Widget>[
                const ListTile(
                  title: Text('Here you can view and edit stock data:'),
                ),
                const Divider(), //----------------------------------------------------

                ListTile(
                  // title + create stock button
                  leading: const Icon(Icons.add_circle),
                  title: const Text('Create new stock'),
                  subtitle: Row(children: [
                    const Text("              "),
                    const Text("Last created:  "),
                    Text(ethUtils.matCreated!),
                    const Text("  "),
                    Text(ethUtils.qtyCreated!),
                  ]),
                  trailing: ElevatedButton(
                      child: const Text('create'),
                      onPressed: () {
                        if (_createMatNameController.text.isEmpty) return;
                        ethUtils.createStock(_createMatNameController.text,
                            _createMatQtyController.text);
                        _createMatNameController.clear();
                        _createMatQtyController.clear();
                      }),
                ),

                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.abc),
                  subtitle: TextField(
                    controller: _createMatNameController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter material name'),
                  ),
                ),

                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.onetwothree),
                  subtitle: TextField(
                    controller: _createMatQtyController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter quantity'),
                  ),
                ),
                const Divider(), //----------------------------------------------------

                ListTile(
                  leading: const Icon(Icons.remove_circle),
                  title: const Text('Delete stock'),
                  subtitle: Row(children: [
                    const Text("              "),
                    const Text("Last deleted:  "),
                    Text(ethUtils.matDeleted!),
                    const Text("  "),
                    Text(ethUtils.locDeleted!),
                  ]),
                  trailing: ElevatedButton(
                      child: const Text('delete'),
                      onPressed: () {
                        if (_deleteMatNameController.text.isEmpty) return;
                        ethUtils.deleteStock(_deleteMatNameController.text,
                            _deleteLocNameController.text);
                        _deleteMatNameController.clear();
                        _deleteLocNameController.clear();
                      }),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.abc),
                  subtitle: TextField(
                    controller: _deleteMatNameController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter material name'),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.abc),
                  subtitle: TextField(
                    controller: _deleteLocNameController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter location name'),
                  ),
                ),
                const Divider(), //----------------------------------------------------
                ListTile(
                  leading: const Icon(Icons.remove_red_eye),
                  title: const Text('View list of all materials'),
                  trailing: ElevatedButton(
                      child: const Text('show'),
                      onPressed: () {
                        ethUtils.getAllMaterials();
                      }),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.arrow_forward),
                  //subtitle: Text('resultAllMaterials'),
                  subtitle: Row(children: [
                    Text(ethUtils.allMats!),
                  ]),
                ),
                const Divider(),
              ]),
      ),
    );
  }
}
