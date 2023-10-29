import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:cupertino_base/layout_play.dart';
import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  Random random = Random();


  String defaultTablero = "15x15";
  String defaultMinas = "20";

  static int banderasPuestas=0;
  bool petar =false;
  bool bombasDesactivadas=false;
  List<List<String>> board = [];
  List<List<int>> boardInfo = [];
  List<List<String>> boardScreen = []; //ImageList
  bool gameIsOver = false;
  String gameWinner = '-';

  int midaTauler = 15;
  static int numeroMines = 20;
  bool minesColocades = false;

  ui.Image? imagePlayer;
  ui.Image? imageOpponent;

  ui.Image? image0;
  ui.Image? image1;
  ui.Image? image2;
  ui.Image? image3;
  ui.Image? image4;
  ui.Image? image5;
  ui.Image? image6;
  ui.Image? image7;
  ui.Image? image8;
  ui.Image? imageBomb;
  ui.Image? imageFlag;
  bool imagesReady = false;

  void resetGame() {
    banderasPuestas=0;
     petar =false;
     bombasDesactivadas=false;
    board = [];
    boardInfo = [];
    boardScreen = []; //ImageList
    gameIsOver = false;
    gameWinner = '-';
    if (midaTauler == 9) {
      board = List.generate(9, (index) => List.filled(9, '-'));
      boardScreen = List.generate(9, (index) => List.filled(9, '-'));
    } else if (midaTauler == 15) {
      board = List.generate(15, (index) => List.filled(15, '-'));
      boardScreen = List.generate(15, (index) => List.filled(15, '-'));
    }
    minesColocades = false;
    gameIsOver = false;
    gameWinner = '-';

    notifyListeners();
  }

  // Fa una jugada, primer el jugador després la maquina
  void playMove(int row, int col) {


    if (board[row][col] == 'O') {
      petar=true;
      gameWinner = 'O';
      gameIsOver = true;
      checkGameWinner();
    } else if (boardScreen[row][col] == '-') {
      if (!minesColocades) {
        machinePlay();
      }

      destaparCelda(row, col);

      if (gameWinner == '-') {
        if (!minesColocades) {
          machinePlay();
        }
      }
    }
    int bombasRestantes=0;
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        if (board[i][j]=="O"){
          bombasRestantes+=1;
        }

      }
    }
    if (bombasRestantes==0){
      bombasDesactivadas=true;
      checkGameWinner();
    }


  }

  void destaparCelda(int row, int col) {
    if (row < 0 ||
        row >= midaTauler ||
        col < 0 ||
        col >= midaTauler ||
        board[row][col] == 'X' ||
        boardInfo[row][col] > 0) {
      boardScreen[row][col] = boardInfo[row][col].toString();
      return; // Condición de salida para detener la recursión
    }

    board[row][col] = 'X'; // Destapa la celda actual

    for (int row2 = (row - 1).clamp(0, midaTauler - 1);
        row2 <= (row + 1).clamp(0, midaTauler - 1);
        row2++) {
      for (int col2 = (col - 1).clamp(0, midaTauler - 1);
          col2 <= (col + 1).clamp(0, midaTauler - 1);
          col2++) {
        destaparCelda(row2, col2);
      }
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
          boardInfo[i][j] = infoMines;
        } else {
          boardInfo[i][j] = -1;
        }
      }
    }
    minesColocades = true;
  }

  //
  // Funcion recursiva para ver los numeros al lado de la bomba
  //
  void checkGameWinner() {
    LayoutPlayState.timer.cancel();
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board.length; j++) {}
    }

    if (gameIsOver || bombasDesactivadas) {

      gameWinner = 'O';
    }else{
      gameWinner = '-';
    }

  }

  // Carrega les imatges per dibuixar-les al Canvas
  Future<void> loadImages(BuildContext context) async {
    // Si ja estàn carregades, no cal fer res
    if (imagesReady) {
      notifyListeners();
      return;
    }

    // Força simular un loading
    await Future.delayed(const Duration(milliseconds: 500));

    Image tmpPlayer = Image.asset('assets/images/player.png');
    Image tmpOpponent = Image.asset('assets/images/opponent.png');
    //
    Image tmp0 = Image.asset('assets/images/0.png');
    Image tmp1 = Image.asset('assets/images/1.png');
    Image tmp2 = Image.asset('assets/images/2.png');
    Image tmp3 = Image.asset('assets/images/3.png');
    Image tmp4 = Image.asset('assets/images/4.png');
    Image tmp5 = Image.asset('assets/images/5.png');
    Image tmp6 = Image.asset('assets/images/6.png');
    Image tmp7 = Image.asset('assets/images/7.png');
    Image tmp8 = Image.asset('assets/images/8.png');
    Image tmpFlag = Image.asset('assets/images/flag.png');
    Image tmpBomb = Image.asset('assets/images/bomb.png');

    if (context.mounted) {
      image0 = await convertWidgetToUiImage(tmp0);
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
      imageFlag = await convertWidgetToUiImage(tmpFlag);
    }

    if (context.mounted) {
      imagePlayer = await convertWidgetToUiImage(tmpPlayer);
    }

    if (context.mounted) {
      imageOpponent = await convertWidgetToUiImage(tmpOpponent);
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
