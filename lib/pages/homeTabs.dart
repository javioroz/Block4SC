import 'package:flutter/material.dart';
import 'stocks.dart';
import 'containers.dart';
import 'transport.dart';
import 'locations.dart';
import '../main.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      const Center(child: Stocks()),
      const Center(child: Containers()),
      const Center(child: Transport()),
      const Center(child: Locations()),
    ];
    final _kTabs = <Tab>[
      const Tab(icon: Icon(Icons.auto_awesome_motion), text: 'Stocks'),
      const Tab(icon: Icon(Icons.archive), text: 'Containers'),
      const Tab(icon: Icon(Icons.double_arrow), text: 'Transport'),
      const Tab(icon: Icon(Icons.warehouse), text: 'Locations'),
    ];
    final _kDrawerHeader = UserAccountsDrawerHeader(
      accountName: Text('Dapp: Blockchain 4 Supply Chain'),
      accountEmail: Text('Developer: JaviOroz@proton.me'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.black,
        //child: FlutterLogo(size: 42.0),
        child: Image.asset('assets/img/B4SC_icon_512.png'),
      ),
    );
    final _kDrawerItems = ListView(
      children: <Widget>[
        _kDrawerHeader,
        ListTile(
          title: const Text('To test 1'),
          onTap: () => Navigator.of(context).push(_Action(1)),
        ),
        ListTile(
          title: const Text('To test 2'),
          onTap: () => Navigator.of(context).push(_Action(2)),
        ),
        ListTile(
          title: const Text('To test 2'),
          onTap: () => Navigator.of(context).push(_Action(3)),
        ),
        const Divider(),
        ListTile(
          title: const Text('Change Dark/Light Mode'),
          onTap: () {},
          trailing: Icon(Icons.dark_mode),
        ),
      ],
    );
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.api),
                Text('  Block4SC  '),
                Icon(Icons.link),
              ]),
          //title: const Text('Block4SC'),
          //leading: Image.asset('assets/img/B4SC_icon.png'),
          backgroundColor: Colors.green,
          bottom: TabBar(
            tabs: _kTabs,
          ),
          actions: [
            IconButton(
                icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode),
                onPressed: () {
                  MyApp.themeNotifier.value =
                      MyApp.themeNotifier.value == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light;
                })
          ],
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
        drawer: Drawer(child: _kDrawerItems),
      ),
    );
  }
}

// <void> means this route returns nothing.
class _Action extends MaterialPageRoute<void> {
  _Action(int id)
      : super(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Test $id'),
                elevation: 1.0,
              ),
              body: Center(
                child: Text('Test $id'),
              ),
            );
          },
        );
}
