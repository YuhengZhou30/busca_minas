import 'dart:math';
import 'dart:ui' as ui;
import 'package:cupertino_base/layout_play.dart';
import 'package:flutter/material.dart'; // per a 'CustomPainter'
import 'app_data.dart';

// S'encarrega del dibuix personalitzat del joc
class WidgetTresRatllaPainter extends CustomPainter {
  final AppData appData;

  WidgetTresRatllaPainter(this.appData);

  // Dibuixa les linies del taulell
  void drawBoardLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0;

    for (int i = 0; i < appData.midaTauler - 1; i++) {
      if (i == 0) {
        final double l1 = size.width / appData.midaTauler;
        canvas.drawLine(Offset(l1, 0), Offset(l1, size.height), paint);
      } else {
        final double l1 = (i + 1) * size.width / appData.midaTauler;
        canvas.drawLine(Offset(l1, 0), Offset(l1, size.height), paint);
      }
    }

    for (int i = 0; i < appData.midaTauler - 1; i++) {
      if (i == 0) {
        final double h1 = size.height / appData.midaTauler;
        canvas.drawLine(Offset(0, h1), Offset(size.width, h1), paint);
      } else {
        final double h1 = (i + 1) * size.height / appData.midaTauler;
        canvas.drawLine(Offset(0, h1), Offset(size.width, h1), paint);
      }
    }
  }

  // Dibuixa la imatge centrada a una casella del taulell
  void drawImage(Canvas canvas, ui.Image image, double x0, double y0, double x1,
      double y1) {
    double dstWidth = x1 - x0;
    double dstHeight = y1 - y0;

    double imageAspectRatio = image.width / image.height;
    double dstAspectRatio = dstWidth / dstHeight;

    double finalWidth;
    double finalHeight;

    if (imageAspectRatio > dstAspectRatio) {
      finalWidth = dstWidth;
      finalHeight = dstWidth / imageAspectRatio;
    } else {
      finalHeight = dstHeight;
      finalWidth = dstHeight * imageAspectRatio;
    }

    double offsetX = x0 + (dstWidth - finalWidth) / 2;
    double offsetY = y0 + (dstHeight - finalHeight) / 2;
    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(offsetX, offsetY, finalWidth, finalHeight);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  // Dibuia una creu centrada a una casella del taulell
  void drawCross(Canvas canvas, double x0, double y0, double x1, double y1,
      Color color, double strokeWidth) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    canvas.drawLine(
      Offset(x0, y0),
      Offset(x1, y1),
      paint,
    );
    canvas.drawLine(
      Offset(x1, y0),
      Offset(x0, y1),
      paint,
    );
  }


  void drawFlag(Canvas canvas, double x, double y, double cellWidth, double cellHeight, AppData appData) {
    double flagWidth = cellWidth ;
    double flagHeight = cellHeight ;
    double flagX = x + (cellWidth - flagWidth) / 2;
    double flagY = y + (cellHeight - flagHeight) / 2;

    if (appData.imageFlag != null) {
      canvas.drawImageRect(
          appData.imageFlag!,
          Rect.fromLTWH(0, 0, appData.imageFlag!.width.toDouble(), appData.imageFlag!.height.toDouble()),
          Rect.fromLTWH(flagX, flagY, flagWidth, flagHeight),
          Paint()
      );
    }

    double strokeWidth = flagWidth * 0.05;
    double crossSize = flagWidth * 0.6;

    double x0 = flagX + (flagWidth - crossSize) / 2;
    double y0 = flagY + (flagHeight - crossSize) / 2;
    double x1 = x0 + crossSize;
    double y1 = y0 + crossSize;
  }
  // Dibuixa un cercle centrat a una casella del taulell
  void drawCircle(Canvas canvas, double x, double y, double radius, Color color,
      double strokeWidth) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  // Dibuixa el taulell de joc (creus i rodones)
  void drawBoardStatus(Canvas canvas, Size size) {
    // Dibuixar 'X' i 'O' del tauler
    double cellWidth = size.width / appData.midaTauler;
    double cellHeight = size.height / appData.midaTauler;

    for (int i = 0; i < appData.midaTauler; i++) {
      for (int j = 0; j < appData.midaTauler; j++) {
        if (appData.board[i][j] == 'X') {
          // Dibuixar una X amb el color del jugador
          /*
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
          */

          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.image0!, x0, y0, x1, y1);
          //drawCross(canvas, x0, y0, x1, y1, color, 5.0);
        } else if (appData.board[i][j] == 'O' && appData.petar) {
          // Dibuixar una O amb el color de l'oponent
          /*
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
          */

          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          double cX = x0 + (x1 - x0) / 2;
          double cY = y0 + (y1 - y0) / 2;
          double radius = (min(cellWidth, cellHeight) / 2) - 5;

          drawImage(canvas, appData.imageBomb!, x0, y0, x1, y1);
          //drawImage(canvas, appData.imageOpponent!, x0, y0, x1, y1);
          //void drawCross(Canvas canvas, double x0, double y0, double x1, double y1, Color color, double strokeWidth) {

          //drawCircle(canvas, cX, cY, radius, color, 5.0);
        } else if (appData.boardScreen[i][j] == '1') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.image1!, x0, y0, x1, y1);
        } else if (appData.boardScreen[i][j] == '2') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.image2!, x0, y0, x1, y1);
        } else if (appData.boardScreen[i][j] == '3') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.image3!, x0, y0, x1, y1);
        } else if (appData.boardScreen[i][j] == '4') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.image4!, x0, y0, x1, y1);
        } else if (appData.boardScreen[i][j] == '5') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.image5!, x0, y0, x1, y1);
        } else if (appData.boardScreen[i][j] == '6') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.image6!, x0, y0, x1, y1);
        } else if (appData.boardScreen[i][j] == '7') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.image7!, x0, y0, x1, y1);
        } else if (appData.boardScreen[i][j] == '8') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.image8!, x0, y0, x1, y1);
        }else if (appData.board[i][j] == 'F') {
          // Dibuja una F (bandera) con el color de la bandera
          // Puedes definir el color de la bandera como desees
          Color flagColor = Colors.red;
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          drawFlag(canvas, x0, y0, cellWidth, cellWidth, appData);


        }


        //*/
      }
    }
  }

  // Dibuixa el missatge de joc acabat
  void drawGameOver(Canvas canvas, Size size) {

    String message="";
    if (appData.petar){
       message = "BOOMM!";
    }else{
       message = "Eres un puto crack!";
    }



    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: message, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: size.width,
    );

    // Centrem el text en el canvas
    final position = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Dibuixar un rectangle semi-transparent que ocupi tot l'espai del canvas
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7) // Ajusta l'opacitat com vulguis
      ..style = PaintingStyle.fill;

    canvas.drawRect(bgRect, paint);

    // Ara, dibuixar el text
    textPainter.paint(canvas, position);
  }


  // Funció principal de dibuix
  @override
  void paint(Canvas canvas, Size size) {
    drawBoardLines(canvas, size);
    drawBoardStatus(canvas, size);
    if (appData.gameWinner != '-') {
      drawGameOver(canvas, size);
    }
  }

  // Funció que diu si cal redibuixar el widget
  // Normalment hauria de comprovar si realment cal, ara només diu 'si'
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
