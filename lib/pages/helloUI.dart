import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/eth.dart';

class HelloUI extends ConsumerStatefulWidget {
  const HelloUI({Key? key}) : super(key: key);

  @override
  _HelloUIState createState() => _HelloUIState();
}

class _HelloUIState extends ConsumerState<HelloUI> {
  //final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.watch(ethUtilsProviders);
    final ethUtils = ref.watch(ethUtilsProviders.notifier);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ethUtils.isLoading
              ? const CircularProgressIndicator()
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _dataController,
                        decoration: const InputDecoration(
                          hintText: 'Enter a name!',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_dataController.text.isEmpty) return;
                            ethUtils.setData(_dataController.text);
                            _dataController.clear();
                          },
                          child: const Text('Set Name'),
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Flexible(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text("Hello "),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(ethUtils.deployedData!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
