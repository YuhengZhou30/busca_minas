import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'layout_play.dart';
import 'widget_tresratlla_painter.dart';
class WidgetTresRatlla extends StatefulWidget {
  const WidgetTresRatlla({Key? key}) : super(key: key);

  @override
  WidgetTresRatllaState createState() => WidgetTresRatllaState();
}

class WidgetTresRatllaState extends State<WidgetTresRatlla> {
  Future<void>? _loadImagesFuture;

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

    return Expanded(
      child: GestureDetector(
        onTapUp: (TapUpDetails details) {
          final int row = calculateRow(details.localPosition.dy);
          final int col = calculateCol(details.localPosition.dx);
          appData.playMove(row, col);
          setState(() {});
        },
        onSecondaryTapDown: (TapDownDetails details) {
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
          width: boardSize,
          height: boardSize,
          child: FutureBuilder(
            future: _loadImagesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CupertinoActivityIndicator();
              } else {
                return CustomPaint(
                  size: Size(boardSize, boardSize),
                  painter: WidgetTresRatllaPainter(appData),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}