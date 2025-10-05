import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

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
                Rank.values[7 - target!.dy ~/ squareSize],
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
                    top: (7 - e.$1.rank.value) * squareSize,
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

class LocalChessApp extends StatefulWidget {
  const LocalChessApp({super.key});

  @override
  State<LocalChessApp> createState() => _LocalChessAppState();
}

class _LocalChessAppState extends State<LocalChessApp> {
  Position position = Chess.fromSetup(Setup.standard);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Chessboard(
            position: position,
            move: (move) {
              setState(() {
                position = position.play(move);
              });
            },
          ),
        ],
      ),
    );
  }
}

class CoinIcon extends StatelessWidget {
  const CoinIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.yellow, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),);
  }
}