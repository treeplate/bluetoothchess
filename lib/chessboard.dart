import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

class Chessboard extends StatefulWidget {
  const Chessboard({super.key, required this.position, required this.move});
  final Position position;
  final void Function(NormalMove move) move;

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
              NormalMove move = NormalMove(from: movedSquare!, to: square);
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

Map<Role, int> values = {
  Role.pawn: 1,
  Role.bishop: 2,
  Role.knight: 3,
  Role.rook: 4,
  Role.queen: 7,
  Role.king: 10,
};

class _LocalChessAppState extends State<LocalChessApp> {
  Position position = Chess.fromSetup(Setup.standard);
  Role promoteTo = Role.queen;
  int wCoins = 0;
  int bCoins = 0;
  Random r = Random();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Chessboard(
            position: position,
            move: (NormalMove move) {
              setState(() {
                if (position.isLegal(move.withPromotion(promoteTo))) {
                  move = move.withPromotion(promoteTo);
                }
                Role? destinationPiece = position.board.pieceAt(move.to)?.role;
                Role? sourcePiece = position.board.pieceAt(move.from)?.role;
                if (destinationPiece == Role.knight) {
                  if (position.turn == Side.white) {
                    wCoins += 3;
                  } else {
                    bCoins += 3;
                  }
                }
                if (sourcePiece == Role.knight && destinationPiece != null) {
                  if (position.turn == Side.white) {
                    wCoins += values[destinationPiece]!;
                  } else {
                    bCoins += values[destinationPiece]!;
                  }
                }
                position = position.play(move);
                if (position.isCheckmate) {
                  if (position.turn == Side.white) {
                    if (!position.checkers.isDisjoint(position.board.knights)) {
                      wCoins += values[Role.king]!;
                    }
                  } else {
                    if (!position.checkers.isDisjoint(position.board.knights)) {
                      bCoins += values[Role.king]!;
                    }
                  }
                }
                if (position.isGameOver) {
                  position = Chess.initial;
                }
              });
            },
          ),
          Material(
            child: RadioGroup<Role>(
              groupValue: promoteTo,
              onChanged: (Role? value) {
                setState(() {
                  promoteTo = value!;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: Role.queen),
                      Text('Queen'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: Role.rook),
                      Text('Rook'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: Role.bishop),
                      Text('Bishop'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: Role.knight),
                      Text('Knight'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CoinIcon(),
                  Text(bCoins.toString()),
                  OutlinedButton(
                    onPressed:
                        bCoins >= 3 &&
                            position.turn == Side.black &&
                            position.checkers.isEmpty
                        ? () => summonHorsey(Side.black)
                        : null,
                    child: Text('Call for backup (3 horsecoins)'),
                  ),
                ],
              ),
              SizedBox(height: 320 - 40 * 2 - 8 * 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CoinIcon(),
                  Text(wCoins.toString()),
                  OutlinedButton(
                    onPressed:
                        wCoins >= 3 &&
                            position.turn == Side.white &&
                            position.checkers.isEmpty
                        ? () => summonHorsey(Side.white)
                        : null,
                    child: Text('Call for backup (3 horsecoins)'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void summonHorsey(Side color) {
    List<Square> emptySquares = [];
    int x = 0;
    int y = 0;
    while (y < 8) {
      if (position.board.pieceAt(Square(x + y * 8)) == null) {
        emptySquares.add(Square(x + y * 8));
      }
      x++;
      if (x == 8) {
        y++;
        x = 0;
      }
    }
    setState(() {
      if (color == Side.white) {
        wCoins -= 3;
      } else {
        bCoins -= 3;
      }
      if (emptySquares.isEmpty) {
        position = position.copyWith(
          board: position.board.setPieceAt(
            Square(r.nextInt(64)),
            Piece(color: color, role: Role.knight),
          ),
          turn: color.opposite,
        );
      } else {
        position = position.copyWith(
          board: position.board.setPieceAt(
            emptySquares[r.nextInt(emptySquares.length)],
            Piece(color: color, role: Role.knight),
          ),
          turn: color.opposite,
        );
      }
      if (!position.board.kings.moreThanOne) {
        if (position.board.white.isDisjoint(position.board.kings)) {
          bCoins += values[Role.king]!;
        } else {
          wCoins += values[Role.king]!;
        }
        position = Chess.initial;
        return;
      }
      if (position.isCheckmate) {
        if (color == Side.white) {
          wCoins += values[Role.king]!;
        } else {
          bCoins += values[Role.king]!;
        }
      }
      if (position.isGameOver) {
        position = Chess.initial;
      }
    });
  }
}

class CoinIcon extends StatelessWidget {
  const CoinIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.yellow,
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.orangeAccent,
            ),
            width: 30,
            height: 30,
            child: Center(
              child: Text(
                'N',
                style: TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.none,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
