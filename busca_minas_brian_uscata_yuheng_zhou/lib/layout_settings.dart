import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';

class LayoutSettings extends StatefulWidget {
  const LayoutSettings({Key? key}) : super(key: key);

  @override
  LayoutSettingsState createState() => LayoutSettingsState();
}

class LayoutSettingsState extends State<LayoutSettings> {
  List<String> midaTaulell = ["9x9", "15x15"];
  List<String> numMinas = ["5", "10", "20"];

  // Mostra el CupertinoPicker en un diàleg.
  void _showPicker(String type) {
    List<String> options = type == "taulell" ? midaTaulell : numMinas;
    String title = type == "taulell"
        ? "Selecciona la mida del taulell"
        : "Selecciona numeros de mines";

    // Troba l'índex de la opció actual a la llista d'opcions
    AppData appData = Provider.of<AppData>(context, listen: false);
    String currentValue =
        type == "taulell" ? appData.colorPlayer : appData.colorOpponent;
    int currentIndex = options.indexOf(currentValue);
    FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: currentIndex);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              color: CupertinoColors.secondarySystemBackground
                  .resolveFrom(context),
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController: scrollController,
                  onSelectedItemChanged: (index) {
                    if (type == "taulell") {
                      appData.colorPlayer = options[index];
                    } else {
                      appData.colorOpponent = options[index];
                    }
                    // Actualitzar el widget
                    setState(() {});
                  },
                  children: options
                      .map((color) => Center(child: Text(color)))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Configuració"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Mida del Taulell: "),
              CupertinoButton(
                onPressed: () => _showPicker("taulell"),
                child: Text(appData.colorPlayer),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Numeros de mines: "),
              CupertinoButton(
                onPressed: () => _showPicker("mines"),
                child: Text(appData.colorOpponent),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
