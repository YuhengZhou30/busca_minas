import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart'; // para 'CustomPainter'
import 'app_data.dart';

class WidgetTresRatllaPainter extends CustomPainter {
  final AppData appData;

  WidgetTresRatllaPainter(this.appData);

  void drawBoardLines(Canvas canvas, Size size) {
  final paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 5.0;

  double cellWidth = size.width / appData.midaTauler;
  double cellHeight = size.height / appData.midaTauler;

  for (int i = 0; i < appData.midaTauler - 1; i++) {
    final double l1 = (i + 1) * cellWidth;
    canvas.drawLine(Offset(l1, 0), Offset(l1, size.height), paint);
  }

  for (int i = 0; i < appData.midaTauler - 1; i++) {
    final double h1 = (i + 1) * cellHeight;
    canvas.drawLine(Offset(0, h1), Offset(size.width, h1), paint);
  }
}


  void drawImage(Canvas canvas, ui.Image image, double x0, double y0, double x1, double y1) {
  final dstRect = Rect.fromPoints(Offset(x0, y0), Offset(x1, y1));
  canvas.drawImageRect(image, Rect.fromPoints(Offset(0, 0), Offset(image.width.toDouble(), image.height.toDouble())), dstRect, Paint());
}


  void drawCross(Canvas canvas, double x0, y0, double x1, double y1, Color color, double strokeWidth) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    canvas.drawLine(Offset(x0, y0), Offset(x1, y1), paint);
    canvas.drawLine(Offset(x0, y1), Offset(x1, y0), paint);
  }

  void drawCircle(Canvas canvas, double x, double y, double radius, Color color, double strokeWidth) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  void drawBoardStatus(Canvas canvas, Size size) {
    double cellWidth = size.width / appData.midaTauler;
    double cellHeight = size.height / appData.midaTauler;

    for (int i = 0; i < appData.midaTauler; i++) {
      for (int j = 0; j < appData.midaTauler; j++) {
        double x0 = j * cellWidth;
        double y0 = i * cellHeight;
        double x1 = (j + 1) * cellWidth;
        double y1 = (i + 1) * cellHeight;

        if (appData.board[i][j] == 'X') {
          Color color = Colors.blue;
          switch (appData.colorPlayer) {
            case "Blau":
              color = Colors.blue;
              break;
            case "Verd":
              color = Colors.green;
              break;
            case "Gris":
              color = Colors.grey;
              break;
          }

          drawImage(canvas, appData.imagePlayer!, x0, y0, x1, y1);
          drawCross(canvas, x0, y0, x1, y1, color, 5.0);
        } else if (appData.board[i][j] == 'O') {
          Color color = Colors.blue;
          switch (appData.colorOpponent) {
            case "Vermell":
              color = Colors.red;
              break;
            case "Taronja":
              color = Colors.orange;
              break;
            case "Marró":
              color = Colors.brown;
              break;
          }

          double cX = x0 + (x1 - x0) / 2;
          double cY = y0 + (y1 - y0) / 2;
          double radius = (min(cellWidth, cellHeight) / 2) - 5;

          drawImage(canvas, appData.imageOpponent!, x0, y0, x1, y1);
          drawCircle(canvas, cX, cY, radius, color, 5.0);
        }
      }
    }
  }

  void drawGameOver(Canvas canvas, Size size) {
    String message = "El juego ha terminado. ¡Ha ganado ${appData.gameWinner}!";

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: message, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.width);

    final position = Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2);

    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawRect(bgRect, paint);
    textPainter.paint(canvas, position);
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawBoardLines(canvas, size);
    drawBoardStatus(canvas, size);
    if (appData.gameWinner != '-') {
      drawGameOver(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
