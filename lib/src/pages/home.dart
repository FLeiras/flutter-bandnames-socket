import 'dart:io' as platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/src/models/band.dart';
import 'package:band_names/src/widgets/graphic.dart';
import 'package:band_names/src/providers/socket_provider.dart';
import 'package:band_names/src/helpers/add_and_validate_new_band.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on(
      'active-bands',
      _handleActiveBands,
    );
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this.bands = (payload as List)
        .map(
          (band) => Band.fromMap(band),
        )
        .toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketStatus = Provider.of<SocketService>(context).serverStatus;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BandNames',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketStatus == ServerStatus.Online
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: bands.length == 0
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ShowGraph(bands),
                Expanded(
                  child: ListView.builder(
                    itemCount: bands.length,
                    itemBuilder: (context, i) => _bandTile(bands[i]),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewBand(context, (String bandName) {
            setState(() {
              bands.add(
                Band(
                  id: DateTime.now().toString(),
                  name: bandName,
                  votes: 0,
                ),
              );
            });
          });
        },
        elevation: 1,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context);

    if (platform.Platform.isAndroid) {
      return Dismissible(
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) =>
            socketService.socket.emit('delete-band', {'id': band.id}),
        background: Container(
          padding: EdgeInsets.only(left: 8.0),
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete_sweep_rounded,
              color: Colors.white,
            ),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text(
              band.name.substring(0, 2),
            ),
          ),
          title: Text(band.name),
          trailing: Text(
            '${band.votes}',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
        ),
      );
    } else {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            band.name.substring(0, 2),
          ),
        ),
        title: Text(band.name),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              Container(
                width: 30,
                child: Text(
                  '${band.votes}',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              IconButton(
                onPressed: () =>
                    socketService.socket.emit('delete-band', {'id': band.id}),
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      );
    }
  }
}
