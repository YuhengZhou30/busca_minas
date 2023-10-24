import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  Random random = Random();
  // App status
  String colorPlayer = "15x15";
  String colorOpponent = "5";

  List<List<String>> board = [];
  bool gameIsOver = false;
  String gameWinner = '-';

  int midaTauler = 15;
  int numeroMines = 5;
  bool minesColocades = false;

  ui.Image? imagePlayer;
  ui.Image? imageOpponent;
  bool imagesReady = false;
void generateMines() {
  int numberOfMines;

  if (numeroMines == 5 || numeroMines == 10 || numeroMines == 20) {
    numberOfMines = numeroMines;
  } else {
    // Valor predeterminado si numeroMines no es 5, 10 o 20
    numberOfMines = 5;
  }

  int maxRow = midaTauler;
  int maxCol = midaTauler;

  if (midaTauler == 9) {
    maxRow = 9;
    maxCol = 9;
  } else if (midaTauler == 15) {
    maxRow = 15;
    maxCol = 15;
  }

  for (int i = 0; i < numberOfMines; i++) {
    int row, col;
    do {
      // Generar posiciones aleatorias para las bombas
      row = random.nextInt(maxRow);
      col = random.nextInt(maxCol);
    } while (board[row][col] == 'O'); // Asegúrate de que no se coloquen bombas en la misma posición

    // Colocar bomba en la posición aleatoria
    board[row][col] = 'O';
  }
}


void resetGame() {
  if (midaTauler == 9) {
    board = List.generate(9, (index) => List.filled(9, '-'));

    gameIsOver = false;
    gameWinner = '-';
    generateMines();
    // Agregar lógica para generar bombas en posiciones aleatorias
    
  } else if (midaTauler == 15) {
    board = List.generate(15, (index) => List.filled(15, '-'));

    gameIsOver = false;
    gameWinner = '-';
    generateMines();
  }
}



  // Fa una jugada, primer el 
  //jugador després la maquina
  void playMove(int row, int col) {
    if (board[row][col] == '-') {
      board[row][col] = 'X';
      checkGameWinner();
      /** 
      if (gameWinner == '-') {
        machinePlay();
      }
      */
    }
  }

  // Fa una jugada de la màquina, només busca la primera posició lliure
  /** 
  void machinePlay() {
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
    while (numeroMines != 0) {
      int fila = random.nextInt(midaTauler);
      int columna = random.nextInt(midaTauler);
      if (board[fila][columna] != 'X') {
        board[fila][columna] = 'O';
        numeroMines--;
      }

      //print(numeroMines);
    }

    checkGameWinner();
  }
*/
  // Comprova si el joc ja té un tres en ratlla
  // No comprova la situació d'empat
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
    Image tmpOpponent = Image.asset('assets/images/bomb.png');

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
