import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/src/providers/socket_provider.dart';

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
            ),
            child: const Text('Add'),
          )
        ],
      );
    },
  );
}

validateNewBand(String bandName, BuildContext context) {
  if (bandName.length > 3) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.emit('add-band', {'name': bandName});
  }

  Navigator.pop(context);
}
