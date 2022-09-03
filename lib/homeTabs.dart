import 'package:block4sc/pages/tests.dart';
import 'package:flutter/material.dart';
import 'pages/stocks.dart';
import 'pages/containers.dart';
import 'pages/transport.dart';
import 'pages/locations.dart';
import 'pages/helloUI.dart';
import 'main.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kTabPages = <Widget>[
      const Center(child: Stocks()),
      const Center(child: Containers()),
      const Center(child: Transport()),
      const Center(child: Locations()),
    ];
    final kTabs = <Tab>[
      const Tab(icon: Icon(Icons.auto_awesome_motion), text: 'Stocks'),
      const Tab(icon: Icon(Icons.archive), text: 'Containers'),
      const Tab(icon: Icon(Icons.double_arrow), text: 'Transport'),
      const Tab(icon: Icon(Icons.warehouse), text: 'Locations'),
    ];
    final kDrawerHeader = UserAccountsDrawerHeader(
      accountName: const Text('Dapp: Blockchain 4 Supply Chain'),
      accountEmail: const Text('Developer: JaviOroz@proton.me'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.black,
        //child: FlutterLogo(size: 42.0),
        child: Image.asset('assets/img/B4SC_icon_512.png'),
      ),
    );
    final kDrawerItems = ListView(
      children: <Widget>[
        kDrawerHeader,
        ListTile(
          title: const Text('Hello'),
          onTap: () => Navigator.of(context).push(_GoToHello()),
        ),
        const Divider(),
        ListTile(
          title: const Text('Tests'),
          onTap: () => Navigator.of(context).push(_GoToTests()),
        ),
        const Divider(),
      ],
    );
    final kAppBar = AppBar(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(Icons.api),
            Text(' Block4SC '),
            Icon(Icons.link),
          ]),
      bottom: TabBar(
        tabs: kTabs,
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
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        // this function minimizes touch keyboard
        // when tapping on any part of screen
      },
      child: DefaultTabController(
        length: kTabs.length,
        child: Scaffold(
          appBar: kAppBar,
          body: TabBarView(
            children: kTabPages,
          ),
          drawer: Drawer(child: kDrawerItems),
        ),
      ),
    );
  }
}

class _GoToHello extends MaterialPageRoute<void> {
  _GoToHello()
      : super(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Hola'),
                elevation: 1.0,
              ),
              body: const Center(
                child: HelloUI(),
              ),
            );
          },
        );
}

class _GoToTests extends MaterialPageRoute<void> {
  _GoToTests()
      : super(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Tests'),
                elevation: 1.0,
              ),
              body: const Center(
                child: Tests(),
              ),
            );
          },
        );
}
