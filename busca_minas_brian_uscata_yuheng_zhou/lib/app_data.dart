import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'layout_play.dart';

class AppData with ChangeNotifier {
  Random random = Random();

  // App status
  String colorPlayer = "Verd";
  String colorOpponent = "Taronja";

  List<List<String>> board = [];
  List<List<int>> boardInfo = [];
  bool gameIsOver = false;
  String gameWinner = '-';

  int midaTauler = 9;
  int numeroMines = 20;
  bool minesColocades = false;


  ui.Image? imageFlag ;
  ui.Image? noDescubierto;

  ui.Image? image0;
  ui.Image? image1;
  ui.Image? image2 ;
  ui.Image? image3;
  ui.Image? image4;
  ui.Image? image5;
  ui.Image? image6;
  ui.Image? image7;
  ui.Image? image8;
  ui.Image? imageBomb;

  bool imagesReady = false;

  void resetGame() {
    LayoutPlayState.contador=0;
    if (midaTauler == 9) {
      board = List.generate(9, (index) => List.filled(9, '-'));
    } else if (midaTauler == 15) {
      board = List.generate(15, (index) => List.filled(15, '-'));
    }
    minesColocades = false;
    gameIsOver = false;
    gameWinner = '-';

  }

  // Fa una jugada, primer el jugador després la maquina
  void playMove(int row, int col) {
    if (board[row][col] == '-') {
      if (!minesColocades) {
        machinePlay();
      }

      if (boardInfo[row][col] == 0) {
        destaparCelda(row, col);
      } else {
        board[row][col] = boardInfo[row][col].toString();
      }

      checkGameWinner();
      if (gameWinner == '-') {
        if (!minesColocades) {
          machinePlay();
        }
      }
    } else if (board[row][col] == 'O') {
      gameWinner = 'O';
      gameIsOver = true;
    }
    LayoutPlayState.contador+=1;
  }

  void destaparCelda(int row, int col) {
    if (row < 0 ||
        row >= midaTauler ||
        col < 0 ||
        col >= midaTauler ||
        board[row][col] != '-' ||
        boardInfo[row][col] == -1) {
      return; // Condición de salida para detener la recursión
    }

    if (boardInfo[row][col] == 0) {
      board[row][col] = '0';
      for (int row2 = (row - 1).clamp(0, midaTauler - 1);
      row2 <= (row + 1).clamp(0, midaTauler - 1);
      row2++) {
        for (int col2 = (col - 1).clamp(0, midaTauler - 1);
        col2 <= (col + 1).clamp(0, midaTauler - 1);
        col2++) {
          destaparCelda(row2, col2);
        }
      }
    } else {
      board[row][col] = boardInfo[row][col].toString();
    }
  }

  //
  // Coloca las bombas al inicio de la partida
  //
  void machinePlay() {
    boardInfo =
        List.generate(midaTauler, (index) => List<int>.filled(midaTauler, 0));

    //bool moveMade = false;

    // Buscar una casella lliure '-'
    /*
    for (int i = 0; i < midaTauler; i++) {
      for (int j = 0; j < midaTauler; j++) {
        if (board[i][j] == '-') {
          board[i][j] = 'O';
          moveMade = true;
          break;
        }
      }
      if (moveMade) break;
    }
    */

    for (int i = 0; i < numeroMines;) {
      int fila = random.nextInt(midaTauler);
      int columna = random.nextInt(midaTauler);
      if (board[fila][columna] != 'X' && board[fila][columna] != 'O') {
        board[fila][columna] = 'O';
        i++;
      }
    }

    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[0].length; j++) {
        if (board[i][j] != 'O') {
          int infoMines = 0;
          for (int rowOffset = -1; rowOffset <= 1; rowOffset++) {
            for (int colOffset = -1; colOffset <= 1; colOffset++) {
              int newRow = i + rowOffset;
              int newCol = j + colOffset;
              if (newRow >= 0 &&
                  newRow < midaTauler &&
                  newCol >= 0 &&
                  newCol < midaTauler) {
                if (board[newRow][newCol] == 'O') {
                  infoMines++;
                }
              }
            }
          }
          //board[i][j] = infoMines.toString();
          boardInfo[i][j] = infoMines;
        } else {
          boardInfo[i][j] = -1;
        }
      }
    }
    minesColocades = true;
    checkGameWinner();
  }

  //
  // Funcion recursiva para ver los numeros al lado de la bomba
  //
  void checkGameWinner() {
    for (int i = 0; i < 3; i++) {
      // Comprovar files
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0] != '-') {
        //gameIsOver = true;
        //gameWinner = board[i][0];
        return;
      }

      // Comprovar columnes
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i] != '-') {
        //gameIsOver = true;
        //gameWinner = board[0][i];
        return;
      }
    }

    // Comprovar diagonal principal
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0] != '-') {
      //gameIsOver = true;
      //gameWinner = board[0][0];
      return;
    }

    // Comprovar diagonal secundària
    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2] != '-') {
      //gameIsOver = true;
      //gameWinner = board[0][2];
      return;
    }

    // No hi ha guanyador, torna '-'
    gameWinner = '-';
  }

  // Carrega les imatges per dibuixar-les al Canvas
  Future<void> loadImages(BuildContext context) async {
    // Si ja estàn carregades, no cal fer ress
    if (imagesReady) {
      notifyListeners();
      return;
    }

    // Força simular un loading
    await Future.delayed(const Duration(milliseconds: 500));
    Image tmpfacingdown = Image.asset('assets/images/facingDown.png');
    Image flagImageAsset = Image.asset('assets/images/flag.png');

    Image tmp0 = Image.asset('assets/images/0.png');
    Image tmp1 = Image.asset('assets/images/1.png');
    Image tmp2 = Image.asset('assets/images/2.png');
    Image tmp3 = Image.asset('assets/images/3.png');
    Image tmp4 = Image.asset('assets/images/4.png');
    Image tmp5 = Image.asset('assets/images/5.png');
    Image tmp6 = Image.asset('assets/images/6.png');
    Image tmp7 = Image.asset('assets/images/7.png');
    Image tmp8 = Image.asset('assets/images/8.png');
    Image tmpBomb = Image.asset('assets/images/bomb.png');

    // Carrega les imatges
    if (context.mounted) {
      image0= await convertWidgetToUiImage(tmp0);
    }
    if (context.mounted) {
      image1 = await convertWidgetToUiImage(tmp1);
    }
    if (context.mounted) {
      image2 = await convertWidgetToUiImage(tmp2);
    }
    if (context.mounted) {
      image3 = await convertWidgetToUiImage(tmp3);
    }
    if (context.mounted) {
      image4 = await convertWidgetToUiImage(tmp4);
    }
    if (context.mounted) {
      image5 = await convertWidgetToUiImage(tmp5);
    }
    if (context.mounted) {
      image6 = await convertWidgetToUiImage(tmp6);
    }
    if (context.mounted) {
      image7 = await convertWidgetToUiImage(tmp7);
    }
    if (context.mounted) {
      image8 = await convertWidgetToUiImage(tmp8);
    }
    if (context.mounted) {
      imageBomb = await convertWidgetToUiImage(tmpBomb);
    }

    if (context.mounted) {
      imageFlag  = await convertWidgetToUiImage(flagImageAsset);
    }
    if (context.mounted) {
      noDescubierto  = await convertWidgetToUiImage(tmpfacingdown);
    }
    imagesReady = true;

    // Notifica als escoltadors que les imatges estan carregades
    notifyListeners();
  }

  // Converteix les imatges al format vàlid pel Canvas
  Future<ui.Image> convertWidgetToUiImage(Image image) async {
    final completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (info, _) => completer.complete(info.image),
          ),
        );
    return completer.future;
  }
}
