import 'package:flutter/material.dart';

addNewBand(
  BuildContext context,
  Function(String) addBandNameCallback,
) {
  final controllerBandName = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Band Name'),
        content: TextField(
          controller: controllerBandName,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => validateNewBand(
              controllerBandName.text,
              context,
              addBandNameCallback,
            ),
            child: const Text('Add'),
          )
        ],
      );
    },
  );
}

validateNewBand(
    String bandName, BuildContext context, Function(String) addBandCallback) {
  if (bandName.length > 3) {
    addBandCallback(bandName);
  }

  Navigator.pop(context);
}
