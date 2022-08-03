import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/eth.dart';

class Transport extends ConsumerStatefulWidget {
  const Transport({Key? key}) : super(key: key);

  @override
  _TransportState createState() => _TransportState();
}

class _TransportState extends ConsumerState<Transport> {
  final TextEditingController _contToSendController = TextEditingController();
  final TextEditingController _contToReceiveController =
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
                  title: Text(
                      'Here you can set the timestamp when a container was sent and received:'),
                ),
                const Divider(), //----------------------------------------------------
                ListTile(
                  leading: const Icon(Icons.send),
                  title: const Text('Send container'),
                  trailing: ElevatedButton(
                      child: const Text('send'),
                      onPressed: () {
                        if (_contToSendController.text.isEmpty) return;
                        ethUtils.sendContainer(_contToSendController.text);
                        _contToSendController.clear();
                      }),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.onetwothree),
                  subtitle: TextField(
                    controller: _contToSendController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter Container ID'),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.arrow_forward),
                  subtitle: Row(
                    children: [
                      const Text('Container sent at: '),
                      Text(ethUtils.timeSent!),
                    ],
                  ),
                ),
                const Divider(), //----------------------------------------------------
                ListTile(
                  leading: const Icon(Icons.inbox),
                  title: const Text('Receive container'),
                  trailing: ElevatedButton(
                      child: const Text('receive'),
                      onPressed: () {
                        if (_contToReceiveController.text.isEmpty) return;
                        ethUtils
                            .receiveContainer(_contToReceiveController.text);
                        _contToReceiveController.clear();
                      }),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.onetwothree),
                  subtitle: TextField(
                    controller: _contToReceiveController,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(hintText: 'Enter Container ID'),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  leading: const Icon(Icons.arrow_forward),
                  subtitle: Row(
                    children: [
                      const Text('Container received at: '),
                      Text(ethUtils.timeReceived!),
                    ],
                  ),
                ),
                const Divider(), //----------------------------------------------------
              ]),
      ),
    );
  }
}
