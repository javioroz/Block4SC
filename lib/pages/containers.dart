import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/eth.dart';

class Containers extends ConsumerStatefulWidget {
  const Containers({Key? key}) : super(key: key);

  @override
  _ContainersState createState() => _ContainersState();
}

class _ContainersState extends ConsumerState<Containers> {
  final TextEditingController _setContIDController = TextEditingController();
  final TextEditingController _setMatNameController = TextEditingController();
  final TextEditingController _setMatQtyController = TextEditingController();
  final TextEditingController _setOriginController = TextEditingController();
  final TextEditingController _setDestinyController = TextEditingController();
  final TextEditingController _getContIDController = TextEditingController();

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
                  title: Text('Here you can view and edit container data:'),
                ),
                const Divider(), //----------------------------------------------------
                ListTile(
                  // title + set cont data button
                  leading: const Icon(Icons.add_circle),
                  title: const Text('Set container data'),
                  subtitle: Row(children: [
                    const Text("              "),
                    const Text("Last container saved:  "),
                    Text(ethUtils.contSaved!),
                    const Text("  "),
                    Text(ethUtils.matSaved!),
                    const Text("  "),
                    Text(ethUtils.qtySaved!),
                    const Text("  "),
                    Text(ethUtils.origSaved!),
                    const Text("  "),
                    Text(ethUtils.destSaved!),
                  ]),
                  trailing: ElevatedButton(
                      child: const Text('create'),
                      onPressed: () {
                        if (_setContIDController.text.isEmpty) return;
                        ethUtils.setContData(
                            _setContIDController.text,
                            _setMatNameController.text,
                            _setMatQtyController.text,
                            _setOriginController.text,
                            _setDestinyController.text);
                        _setContIDController.clear();
                        _setMatNameController.clear();
                        _setMatQtyController.clear();
                        _setOriginController.clear();
                        _setDestinyController.clear();
                      }),
                ),

                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.onetwothree),
                  subtitle: TextField(
                    controller: _setContIDController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter container ID'),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.abc),
                  subtitle: TextField(
                    controller: _setMatNameController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter material name'),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.onetwothree),
                  subtitle: TextField(
                    controller: _setMatQtyController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter quantity'),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.abc),
                  subtitle: TextField(
                    controller: _setOriginController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        hintText: 'Enter origin location'),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.abc),
                  subtitle: TextField(
                    controller: _setDestinyController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        hintText: 'Enter destination location'),
                  ),
                ),
                const Divider(), //----------------------------------------------------

                ListTile(
                  leading: const Icon(Icons.remove_red_eye),
                  title: const Text('Get container data'),
                  trailing: ElevatedButton(
                      child: const Text('show'),
                      onPressed: () {
                        if (_getContIDController.text.isEmpty) return;
                        ethUtils.getContData(_getContIDController.text);
                        _getContIDController.clear();
                      }),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.onetwothree),
                  subtitle: TextField(
                    controller: _getContIDController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter Container ID'),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.arrow_forward),
                  subtitle: Row(children: [
                    const Text('Container Data: '),
                    Text(ethUtils.contData!),
                  ]),
                ),
                const Divider(), //----------------------------------------------------

                ListTile(
                  leading: const Icon(Icons.remove_red_eye),
                  title: const Text('View all container IDs'),
                  trailing: ElevatedButton(
                      child: const Text('show'),
                      onPressed: () {
                        ethUtils.getAllContIDs();
                      }),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.arrow_forward),
                  //subtitle: Text('resultAllMaterials'),
                  subtitle: Row(children: [
                    const Text('All container IDs: '),
                    Text(ethUtils.allContIDs!),
                  ]),
                ),
                const Divider(),
              ]),
      ),
    );
  }
}
