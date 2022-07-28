import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/eth.dart';

class Stocks extends ConsumerStatefulWidget {
  const Stocks({Key? key}) : super(key: key);

  @override
  _StocksState createState() => _StocksState();
}

class _StocksState extends ConsumerState<Stocks> {
  final TextEditingController _matNameController = TextEditingController();
  final TextEditingController _matQtyController = TextEditingController();

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
                  trailing: ElevatedButton(
                      child: const Text('create'),
                      onPressed: () {
                        if (_matNameController.text.isEmpty) return;
                        ethUtils.setData(_matNameController.text);
                        _matNameController.clear();
                      }),
                ),

                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.abc),
                  subtitle: TextField(
                    controller: _matNameController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter material name'),
                  ),
                ),

                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.onetwothree),
                  subtitle: TextField(
                    controller: _matQtyController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter quantity'),
                  ),
                ),
                const Divider(), //----------------------------------------------------

                ListTile(
                  leading: const Icon(Icons.remove_circle),
                  title: const Text('Delete stock'),
                  trailing: ElevatedButton(
                      child: const Text('delete'),
                      onPressed: () {
                        if (_matNameController.text.isEmpty) return;
                        ethUtils.setData(_matNameController.text);
                        _matNameController.clear();
                      }),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.abc),
                  subtitle: TextField(
                    controller: _matNameController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter material name'),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.abc),
                  subtitle: TextField(
                    controller: _matQtyController,
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
                        if (_matNameController.text.isEmpty) return;
                        ethUtils.getData();
                        _matNameController.clear();
                      }),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.arrow_forward),
                  //subtitle: Text('resultAllMaterials'),
                  subtitle: Text(ethUtils.deployedData!),
                ),
                const Divider(),
              ]),
      ),
    );
  }
}
