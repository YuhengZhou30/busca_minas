import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'widget_tresratlla.dart';

class LayoutPlay extends StatefulWidget {
  const LayoutPlay({Key? key}) : super(key: key);

  @override
  LayoutPlayState createState() => LayoutPlayState();
}

class LayoutPlayState extends State<LayoutPlay> {
  int elapsedTime = 0;
  static int contador = 0; // Variable contador
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime++;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centra la barra de navegación
          children: [
            Text('$contador'), // Muestra el contador a la izquierda
            const Text("Partida"),
            Text('$elapsedTime s'), // Muestra el tiempo transcurrido
          ],
        ),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      child: const SafeArea(
        child: WidgetTresRatlla(),
      ),
    );
  }
}