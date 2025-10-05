import 'dart:math';

import 'package:bluetoothchess/pieces.dart';
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
  static const double squareSize = 80;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown,
      child: DragTarget<Square>(
        onWillAcceptWithDetails: (details) {
          movedSquare = details.data;
          return true;
        },
        onLeave: (data) {
          setState(() {
            target = null;
          });
        },
        builder: (BuildContext context, List<Square?> candidates, _) {
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
                      bottom: e.$1.rank.value * squareSize,
                      child: Draggable<Square>(
                        data: e.$1,
                        feedback: SizedBox(
                          width: squareSize,
                          height: squareSize,
                          child: pieceWidget(
                            e.$2,
                            squareSize,
                            widget.position.checkers.squares.contains(e.$1)
                                ? Colors.red
                                : null,
                          ),
                        ),
                        childWhenDragging: SizedBox.square(
                          dimension: squareSize,
                        ),
                        child: SizedBox(
                          width: squareSize,
                          height: squareSize,
                          child: pieceWidget(
                            e.$2,
                            squareSize,
                            widget.position.checkers.squares.contains(e.$1)
                                ? Colors.red
                                : null,
                          ),
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
                  if (candidates.isNotEmpty)
                    ...widget.position
                        .legalMovesOf(candidates.single!)
                        .squares
                        .map(
                          (e) => Positioned(
                            left: e.file.value * squareSize + squareSize / 4,
                            bottom: e.rank.value * squareSize + squareSize / 4,
                            child: Container(
                              width: squareSize / 2,
                              height: squareSize / 2,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(
                                  squareSize / 4,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
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
  int blackWins = 0;
  int whiteWins = 0;
  Random r = Random();
  bool? vsBot;

  int botScore(Square source, Square destination) {
    NormalMove move = NormalMove(from: source, to: destination);
    if (position.isLegal(move.withPromotion(promoteTo))) {
      move = move.withPromotion(promoteTo);
    }
    Position result = position.play(move);
    Iterable<MapEntry<Square, SquareSet>> moves = result.legalMoves.entries;
    for (MapEntry<Square, SquareSet> moveset in moves) {
      Square source2 = moveset.key;
      for (Square destination2 in moveset.value.squares) {
        NormalMove move = NormalMove(from: source2, to: destination2);
        if (result.isLegal(move.withPromotion(promoteTo))) {
          move = move.withPromotion(promoteTo);
        }
        Position result2 = result.play(move);
        if (result2.isCheckmate) return -1;
      }
    }
    if (result.isCheckmate) {
      if (position.board.pieceAt(source)!.role == Role.knight) {
        return 2000;
      }
      return 1000;
    }
    if (position.board.pieceAt(source)!.role == Role.knight) {
      int score = values[position.board.pieceAt(destination)?.role] ?? 0;
      if (position.board.pieceAt(destination)?.role == Role.knight) score += 3;
      return score * 10 + 1;
    }
    int score = values[position.board.pieceAt(destination)?.role] ?? 0;
    if (position.board.pieceAt(destination)?.role == Role.knight) score += 3;
    return score;
  }

  void botMove() {
    if (vsBot != true) return;
    if (position.checkers.isEmpty && bCoins >= 3) {
      summonHorsey(Side.black);
      return;
    }
    Iterable<MapEntry<Square, SquareSet>> moves = position.legalMoves.entries;
    int max = -2;
    (Square, Square)? move;
    for (MapEntry<Square, SquareSet> moveset in moves) {
      Square source = moveset.key;
      for (Square destination in moveset.value.squares) {
        int score = botScore(source, destination);
        if (score > max) {
          move = (source, destination);
          max = score;
        }
      }
    }
    doMove(NormalMove(from: move!.$1, to: move.$2));
  }

  @override
  Widget build(BuildContext context) {
    if (vsBot == null) {
      return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      vsBot = true;
                    });
                  },
                  child: Text('Computer'),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      vsBot = false;
                    });
                  },
                  child: Text('Local multiplayer'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IgnorePointer(
                ignoring: position.turn == Side.black && vsBot!,
                child: Chessboard(
                  position: position,
                  move: (NormalMove move) {
                    doMove(move);

                    if (position.turn == Side.black) {
                      botMove();
                    }
                  },
                ),
              ),
              Material(
                color: Colors.transparent,
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
                      Text('Promote to:'),
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
                      Text(
                        position.turn == Side.white
                            ? 'turn: white'
                            : 'turn: black',
                      ),
                      Text('white wins: $whiteWins'),
                      Text('black wins: $blackWins'),
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
                      Text(
                        'Black',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontSize: 20,
                        ),
                      ),
                      CoinIcon(),
                      Text(
                        bCoins.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      if (!vsBot!) OutlinedButton(
                        onPressed:
                            bCoins >= 3 &&
                                position.turn == Side.black &&
                                position.checkers.isEmpty
                            ? () {
                                summonHorsey(Side.black);
                              }
                            : null,
                        child: Text('Call for backup (3 horsecoins)'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _ChessboardState.squareSize * 8 - 40 * 2 - 8 * 3,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'White',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontSize: 20,
                        ),
                      ),
                      CoinIcon(),
                      Text(
                        wCoins.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      OutlinedButton(
                        onPressed:
                            wCoins >= 3 &&
                                position.turn == Side.white &&
                                position.checkers.isEmpty
                            ? () {
                                summonHorsey(Side.white);
                                if (position.turn == Side.black) {
                                  botMove();
                                }
                              }
                            : null,
                        child: Text('Call for backup (3 horsecoins)'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Text(
            'If you take a knight, you get 3 horsecoins.',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'If you take something with a knight, you get the value of that piece.',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Values of pieces:',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Pawn: ${values[Role.pawn]} horsecoin${values[Role.pawn] == 1 ? '' : 's'}',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Bishop: ${values[Role.bishop]} horsecoin${values[Role.bishop] == 1 ? '' : 's'}',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Knight: ${values[Role.knight]} horsecoin${values[Role.knight] == 1 ? '' : 's'}',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Rook: ${values[Role.rook]} horsecoin${values[Role.rook] == 1 ? '' : 's'}',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Queen: ${values[Role.queen]} horsecoin${values[Role.queen] == 1 ? '' : 's'}',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'King: ${values[Role.king]} horsecoin${values[Role.king] == 1 ? '' : 's'}',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void doMove(NormalMove move) {
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
          blackWins++;
          if (!position.checkers.isDisjoint(position.board.knights)) {
            bCoins += values[Role.king]!;
          }
        } else {
          whiteWins++;
          if (!position.checkers.isDisjoint(position.board.knights)) {
            wCoins += values[Role.king]!;
          }
        }
      }
      if (position.isGameOver) {
        position = Chess.initial;
      }
    });
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
          blackWins++;
        } else {
          wCoins += values[Role.king]!;
          whiteWins++;
        }
        position = Chess.initial;
        return;
      }
      if (position.isCheckmate) {
        if (color == Side.white) {
          wCoins += values[Role.king]!;
          whiteWins++;
        } else {
          bCoins += values[Role.king]!;
          blackWins++;
        }
      }
      if (position.isGameOver) {
        position = Chess.initial;
      }
    });
  }
}
