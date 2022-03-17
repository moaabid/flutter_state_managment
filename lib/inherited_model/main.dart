import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _color1 = Colors.yellow;
  var _color2 = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Inherited Model")),
        body: AvailableColorModel(
            color1: _color1,
            color2: _color2,
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _color1 = colors.getRandomElement();
                          });
                        },
                        child: const Text("Change color 1")),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _color2 = colors.getRandomElement();
                          });
                        },
                        child: const Text("Change color 2"))
                  ],
                ),
                const ColorWidget(color: AvailableColors.one),
                const ColorWidget(color: AvailableColors.two),
              ],
            )));
  }
}

enum AvailableColors { one, two }

class AvailableColorModel extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;

  const AvailableColorModel(
      {Key? key,
      required this.color1,
      required this.color2,
      required Widget child})
      : super(key: key, child: child);

  static AvailableColorModel of(BuildContext context, AvailableColors aspect) {
    return InheritedModel.inheritFrom<AvailableColorModel>(context,
        aspect: aspect)!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorModel oldWidget) {
    devtool.log('updateShouldNotify');
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(covariant AvailableColorModel oldWidget,
      Set<AvailableColors> dependencies) {
    devtool.log('updateShouldNotifyDependent');
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }
    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }
    return false;
  }
}

class ColorWidget extends StatelessWidget {
  final AvailableColors color;
  const ColorWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        devtool.log('color one got rebuild');
        break;
      case AvailableColors.two:
        devtool.log('color two get rebuild');
        break;
      default:
    }
    final colorProvider = AvailableColorModel.of(
      context,
      color,
    );
    return Container(
      height: 100,
      color: color == AvailableColors.one
          ? colorProvider.color1
          : colorProvider.color2,
    );
  }
}

final colors = [
  Colors.amber,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.pink,
  Colors.orange,
  Colors.teal,
  Colors.lime,
  Colors.indigo,
  Colors.cyan,
  Colors.brown,
  Colors.grey,

];

extension RandomElements<T> on Iterable<T> {
  T getRandomElement() => elementAt(Random().nextInt(length));
}
