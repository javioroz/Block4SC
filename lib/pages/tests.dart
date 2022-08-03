import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/eth.dart';

class Tests extends ConsumerStatefulWidget {
  const Tests({Key? key}) : super(key: key);

  @override
  _TestsState createState() => _TestsState();
}

class _TestsState extends ConsumerState<Tests> {
  @override
  Widget build(BuildContext context) {
    ref.watch(ethUtilsProviders);
    final ethUtils = ref.watch(ethUtilsProviders.notifier);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text('Click the tests in order.'),
            ),
            Center(
              child: ethUtils.isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                            onPressed: () {
                              ethUtils.test1CreateStock();
                            },
                            child: const Text('Test 1: Create Stock'),
                          ),
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                            onPressed: () {
                              ethUtils.test2SetCont();
                            },
                            child: const Text('Test 2: Set Cont Data'),
                          ),
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                            onPressed: () {
                              ethUtils.test3Send();
                            },
                            child: const Text('Test 3: Send Conts'),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
