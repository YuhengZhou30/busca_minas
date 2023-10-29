import 'package:cupertino_base/layout_play.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'widget_buscaminas_painter.dart';

class WidgetTresRatlla extends StatefulWidget {
  const WidgetTresRatlla({Key? key}) : super(key: key);

  @override
  WidgetTresRatllaState createState() => WidgetTresRatllaState();
}

class WidgetTresRatllaState extends State<WidgetTresRatlla> {
  Future<void>? _loadImagesFuture;

  // Al iniciar el widget, carrega les imatges
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppData appData = Provider.of<AppData>(context, listen: false);
      _loadImagesFuture = appData.loadImages(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    double boardSize = MediaQuery
        .of(context)
        .size
        .shortestSide;
    int calculateRow(double y) {
      return (y * appData.midaTauler / boardSize).floor();
    }

    int calculateCol(double x) {
      return (x * appData.midaTauler / boardSize).floor();
    }

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        if(appData.gameWinner != '-') return;
        final int row = (details.localPosition.dy /
                (context.size!.height / appData.midaTauler))
            .floor();
        final int col = (details.localPosition.dx /
                (context.size!.width / appData.midaTauler))
            .floor();

        appData.playMove(row, col);
        setState(() {}); // Actualitza la vista
      },
      //Click derecho
      onSecondaryTapDown: (TapDownDetails details) {
        if(appData.gameWinner != '-') return;

        AppData.banderasPuestas++;
        final int row = calculateRow(details.localPosition.dy);
        final int col = calculateCol(details.localPosition.dx);

        if (appData.board[row][col] == 'F') {
          appData.board[row][col] = '-';
        } else {
          appData.board[row][col] = 'F';
        }

        setState(() {});
      },

      child: SizedBox(
        width: MediaQuery.of(context)
            .size
            .width, // Ocupa tot l'ample de la pantalla
        height: MediaQuery.of(context).size.height -
            56.0, // Ocupa tota l'altura disponible menys l'altura de l'AppBar
        child: FutureBuilder(
          // Segons si les imatges estan disponibles mostra un progrés o el joc
          future: _loadImagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CupertinoActivityIndicator();
            } else {
              //captura los gestos del usuario, como toques en la pantalla.
              return GestureDetector(
                onTapUp: (TapUpDetails details) {
                  if(appData.gameWinner != '-') return;
                  //print(appData.board);
                  //print(appData.board);
                  //print(appData.boardInfo);
                  final int row = (details.localPosition.dy /
                          (context.size!.height / appData.midaTauler))
                      .floor();
                  final int col = (details.localPosition.dx /
                          (context.size!.width / appData.midaTauler))
                      .floor();
                  appData.playMove(row, col);
                  setState(() {}); // Actualitza la vista
                },
                child: SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Ocupa tot l'ample de la pantalla
                  height: MediaQuery.of(context).size.height -
                      56.0, // Ocupa tota l'altura disponible menys l'altura de l'AppBar
                  child: CustomPaint(
                    painter: WidgetTresRatllaPainter(appData),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
