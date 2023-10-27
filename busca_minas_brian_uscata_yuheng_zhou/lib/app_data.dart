import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

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

  ui.Image? imagePlayer;
  ui.Image? imageOpponent;
  bool imagesReady = false;

  void resetGame() {
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

      destaparCelda(row, col);

      board[row][col] = 'X';
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
  }

  void destaparCelda(int row, int col) {
    if (row < 0 ||
        row >= midaTauler ||
        col < 0 ||
        col >= midaTauler ||
        board[row][col] == 'X' ||
        boardInfo[row][col] > 0) {
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
    // Si ja estàn carregades, no cal fer res
    if (imagesReady) {
      notifyListeners();
      return;
    }

    // Força simular un loading
    await Future.delayed(const Duration(milliseconds: 500));

    Image tmpPlayer = Image.asset('assets/images/player.png');
    Image tmpOpponent = Image.asset('assets/images/opponent.png');

    // Carrega les imatges
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
