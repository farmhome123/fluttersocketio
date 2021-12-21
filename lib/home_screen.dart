import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Socket? socket;
  String? _message;
  @override
  void dispose() {
    socket!
        .disconnect(); // --> disconnects the Socket.IO client once the screen is disposed
    super.dispose();
  }

  sendMessage(String message) {
    socket!.emit("newChatMessage", {'body': 'Testfarm'});
  }

  void initializeSocket() {
    socket = io(
        // "https://apisocketio.komkawila.com/",
        //203.159.93.64
        "http://203.159.93.64:4000/",
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({"roomId": '12'})
            .build());
    socket!.connect(); //connect the Socket.IO Client to the Serverƒ
    //SOCKET EVENTS
    // --> listening for connection
    socket!.on('connect', (data) {
      print(socket!.connected);
    });
    //listen for incoming messages from the Server.
    socket!.on('newChatMessage', (data) {
      print(data); //
      setState(() {
        _message = data;
      });
    });
    socket!.on('message', (data) {
      print(data); //
    });

    //listens when the client is disconnected from the Server
    socket!.on('disconnect', (data) {
      print('disconnect');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text('Socketio'),
              FlatButton.icon(
                onPressed: () => sendMessage('Test'),
                icon: const Icon(Icons.ac_unit),
                label: Text('${_message}'
                    .replaceAll('TEMP=', ' ')
                    .replaceAll('#', ' ')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
