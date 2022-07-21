import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/ethHello.dart';

class HelloUI extends ConsumerStatefulWidget {
  const HelloUI({Key? key}) : super(key: key);

  @override
  _HelloUIState createState() => _HelloUIState();
}

class _HelloUIState extends ConsumerState<HelloUI> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.watch(ethUtilsProviders);
    final ethUtils = ref.watch(ethUtilsProviders.notifier);

    return Scaffold(
      //appBar: AppBar(
      //  title: const Text("Hello World!"),
      //  centerTitle: true,
      //),
      body: Container(
        //decoration: const BoxDecoration(
        //    gradient: LinearGradient(
        //        begin: Alignment.topRight,
        //        end: Alignment.bottomLeft,
        //        colors: [Colors.black, (Color.fromARGB(255, 23, 48, 23))])),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ethUtils.isLoading
              ? const CircularProgressIndicator()
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                              child: Text(ethUtils.deployedName!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter a name!',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.lightBlueAccent, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.lightBlueAccent, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                          ),
                          onPressed: () {
                            if (_nameController.text.isEmpty) return;
                            ethUtils.setName(_nameController.text);
                            _nameController.clear();
                          },
                          child: const Text('Set Name'),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
