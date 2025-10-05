import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_ble/universal_ble.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    PeripheralManager();
    runApp(const TypeSelectorApp());
  } on UnimplementedError {
    runApp(const ClientApp());
  }
}

const String service = 'bc42';
const String characteristic = 'caba';

class TypeSelectorApp extends StatelessWidget {
  const TypeSelectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Builder(
        builder: (context) {
          return Column(
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ServerApp()),
                  );
                },
                child: Text('Server'),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClientApp()),
                  );
                },
                child: Text('Client'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ServerApp extends StatefulWidget {
  const ServerApp({super.key});

  @override
  State<ServerApp> createState() => _ServerAppState();
}

class _ServerAppState extends State<ServerApp> {
  Position position = Chess.fromSetup(Setup.standard);

  late final PeripheralManager potato;
  @override
  void initState() {
    super.initState();
    potato = PeripheralManager();
    potato.addService(
      GATTService(
        uuid: UUID.fromString(BleUuidParser.string(service)),
        isPrimary: true,
        includedServices: [],
        characteristics: [
          GATTCharacteristic.mutable(
            uuid: UUID.fromString(BleUuidParser.string(characteristic)),
            properties: [.read, .write],
            permissions: [.read, .write],
            descriptors: [],
          ),
        ],
      ),
    );
    potato.startAdvertising(
      Advertisement(
        name: 'Bluetooth Chess',
        serviceUUIDs: [UUID.fromString(BleUuidParser.string(service))],
      ),
    );
    potato.characteristicReadRequested.listen((data) {
      potato.respondReadRequestWithValue(
        data.request,
        value: Uint8List.fromList(position.fen.codeUnits),
      );
    });
    potato.characteristicWriteRequested.listen((data) {
      potato.respondWriteRequest(data.request);
      setState(() {
        position.play(Move.parse(String.fromCharCodes(data.request.value))!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Chessboard(
      position: position,
      move: (Move move) {
        setState(() {
          position = position.play(move);
        });
      },
    );
  }
}

class Chessboard extends StatefulWidget {
  const Chessboard({super.key, required this.position, required this.move});
  final Position position;
  final void Function(Move move) move;

  @override
  State<Chessboard> createState() => _ChessboardState();
}

class _ChessboardState extends State<Chessboard> {
  Square? movedSquare;
  Offset? target;
  static const double squareSize = 40;
  @override
  Widget build(BuildContext context) {
    return DragTarget<Square>(
      onWillAcceptWithDetails: (details) {
        movedSquare = details.data;
        return true;
      },
      onLeave: (data) {
        setState(() {
          target = null;
        });
      },
      builder: (BuildContext context, _, _) {
        return Listener(
          onPointerDown: (PointerDownEvent event) {
            setState(() {
              target = event.position;
            });
          },
          onPointerUp: (event) {
            if (target == null || movedSquare == null) return;
            setState(() {
              if (!Size(squareSize * 8, squareSize * 8).contains(target!)) {
                target = null;
                movedSquare = null;
                return;
              }
              Square square = Square.fromCoords(
                File.values[target!.dx ~/ squareSize],
                Rank.values[8 - target!.dy ~/ squareSize],
              );
              Move move = NormalMove(from: movedSquare!, to: square);
              if (widget.position.isLegal(move)) {
                widget.move(move);
              }
              target = null;
              movedSquare = null;
            });
          },
          onPointerMove: (PointerMoveEvent event) {
            setState(() {
              target = event.position;
            });
          },
          child: SizedBox(
            width: squareSize * 8,
            height: squareSize * 8,
            child: Stack(
              children: [
                ...widget.position.board.pieces.map(
                  (e) => Positioned(
                    left: e.$1.file.value * squareSize,
                    top: (8 - e.$1.rank.value) * squareSize,
                    child: Draggable<Square>(
                      data: e.$1,
                      feedback: Text(
                        e.$2.fenChar,
                        style: TextStyle(fontSize: squareSize),
                      ),
                      childWhenDragging: SizedBox.square(dimension: squareSize),
                      child: Text(
                        e.$2.fenChar,
                        style: TextStyle(fontSize: squareSize),
                      ),
                    ),
                  ),
                ),
                if (target != null)
                  Positioned(
                    left: target!.dx ~/ squareSize * squareSize,
                    top: target!.dy ~/ squareSize * squareSize,
                    child: Container(
                      width: squareSize,
                      height: squareSize,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ClientApp extends StatefulWidget {
  const ClientApp({super.key});

  @override
  State<ClientApp> createState() => _ClientAppState();
}

class _ClientAppState extends State<ClientApp> {
  bool? bluetoothOn;
  // named by Kipling
  BleCharacteristic? potato;
  Position? position;

  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  void asyncInitState() async {
    await Permission.bluetoothConnect.request().isGranted;
    await Permission.bluetoothScan.request().isGranted;
    AvailabilityState state =
        await UniversalBle.getBluetoothAvailabilityState();
    setState(() {
      bluetoothOn = state == AvailabilityState.poweredOn;
    });
    if (state != AvailabilityState.poweredOff &&
        state != AvailabilityState.poweredOn) {
      throw UnsupportedError('state: $state');
    }
    // Start scan only if Bluetooth is powered on
    if (state == AvailabilityState.poweredOn) {
      UniversalBle.startScan();
    }

    // Listen to bluetooth availability changes using stream
    UniversalBle.availabilityStream.listen((state) {
      setState(() {
        bluetoothOn = state == AvailabilityState.poweredOn;
      });
      if (state != AvailabilityState.poweredOff &&
          state != AvailabilityState.poweredOn) {
        throw UnsupportedError('state: $state');
      }
      if (state == AvailabilityState.poweredOn) {
        UniversalBle.startScan(scanFilter: ScanFilter(withServices: [service]));
      }
    });
    UniversalBle.onScanResult = (BleDevice device) async {
      UniversalBle.onScanResult = null;
      print(device.name);
      await device.connect();
      print(await device.requestMtu(500));
      await device.pair();
      device.getCharacteristic(characteristic, service: service).then((value) {
        setState(() {
          potato = value;
          Timer.periodic(Duration(milliseconds: 100), (timer) async {
            position = Chess.fromSetup(
              Setup.parseFen(String.fromCharCodes(await potato!.read())),
            );

            setState(() {});
          });
        });
      });
    };

    // Or set a handler
    UniversalBle.onAvailabilityChange = (state) {};
  }

  @override
  Widget build(BuildContext context) {
    if (bluetoothOn == null) return CircularProgressIndicator();
    if (bluetoothOn == false) {
      return Text('Bluetooth not turned on. Please turn Bluetooth on.');
    }
    if (position == null) {
      return CircularProgressIndicator();
    }
    return Chessboard(
      position: position!,
      move: (Move move) {
        potato!.write(move.toString().codeUnits);
      },
    );
  }
}
