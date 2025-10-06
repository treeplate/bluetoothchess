import 'package:bluetoothchess/pieces.dart';
import 'package:flutter/material.dart';

class TicTacToeWidget extends StatefulWidget {
  const TicTacToeWidget({super.key});

  @override
  State<TicTacToeWidget> createState() => _TicTacToeWidgetState();
}

class _TicTacToeWidgetState extends State<TicTacToeWidget> {
  int whiteWins = 0;
  int blackWins = 0;
  bool? o0;
  bool? o1;
  bool? o2;
  bool? i0;
  bool? i1;
  bool? i2;
  bool? t0;
  bool? t1;
  bool? t2;
  bool turn = true;

  void checkWin() {
    if (o0 != null && o0 == o1 && o0 == o2) {
      setState(() {
        if (o0!) {
          whiteWins++;
        } else {
          blackWins++;
        }
        o0 = null;
        o1 = null;
        o2 = null;
        i0 = null;
        i1 = null;
        i2 = null;
        t0 = null;
        t1 = null;
        t2 = null;
      });
      return;
    }
    if (o0 != null && o0 == i1 && o0 == t2) {
      setState(() {
        if (o0!) {
          whiteWins++;
        } else {
          blackWins++;
        }
        o0 = null;
        o1 = null;
        o2 = null;
        i0 = null;
        i1 = null;
        i2 = null;
        t0 = null;
        t1 = null;
        t2 = null;
      });
      return;
    }
    if (o0 != null && o0 == i0 && o0 == t0) {
      setState(() {
        if (o0!) {
          whiteWins++;
        } else {
          blackWins++;
        }
        o0 = null;
        o1 = null;
        o2 = null;
        i0 = null;
        i1 = null;
        i2 = null;
        t0 = null;
        t1 = null;
        t2 = null;
      });
      return;
    }
    if (i0 != null && i0 == i1 && i0 == i2) {
      setState(() {
        if (i0!) {
          whiteWins++;
        } else {
          blackWins++;
        }
        o0 = null;
        o1 = null;
        o2 = null;
        i0 = null;
        i1 = null;
        i2 = null;
        t0 = null;
        t1 = null;
        t2 = null;
      });
    }
    if (t0 != null && t0 == t1 && t0 == t2) {
      setState(() {
        if (t0!) {
          whiteWins++;
        } else {
          blackWins++;
        }
        o0 = null;
        o1 = null;
        o2 = null;
        i0 = null;
        i1 = null;
        i2 = null;
        t0 = null;
        t1 = null;
        t2 = null;
      });
      return;
    }
    if (t0 != null && t0 == i1 && t0 == o2) {
      setState(() {
        if (t0!) {
          whiteWins++;
        } else {
          blackWins++;
        }
        o0 = null;
        o1 = null;
        o2 = null;
        i0 = null;
        i1 = null;
        i2 = null;
        t0 = null;
        t1 = null;
        t2 = null;
      });
      return;
    }
    if (o1 != null && o1 == i1 && o1 == t1) {
      setState(() {
        if (o1!) {
          whiteWins++;
        } else {
          blackWins++;
        }
        o0 = null;
        o1 = null;
        o2 = null;
        i0 = null;
        i1 = null;
        i2 = null;
        t0 = null;
        t1 = null;
        t2 = null;
      });
      return;
    }
    if (o2 != null && o2 == i2 && o2 == t2) {
      setState(() {
        if (o2!) {
          whiteWins++;
        } else {
          blackWins++;
        }
        o0 = null;
        o1 = null;
        o2 = null;
        i0 = null;
        i1 = null;
        i2 = null;
        t0 = null;
        t1 = null;
        t2 = null;
      });
      return;
    }
    if (o0 != null &&
        o1 != null &&
        o2 != null &&
        i0 != null &&
        i1 != null &&
        i2 != null &&
        t0 != null &&
        t1 != null &&
        t2 != null) {
      setState(() {
        o0 = null;
        o1 = null;
        o2 = null;
        i0 = null;
        i1 = null;
        i2 = null;
        t0 = null;
        t1 = null;
        t2 = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.brown,
      child: Column(
        children: [
          Text('Black wins: $blackWins'),
          Text('White wins: $whiteWins'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              o0 == null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          o0 = turn;
                          turn = !turn;
                        });
                        checkWin();
                      },
                      icon: SizedBox(width: 40),
                    )
                  : CoinIcon(color: o0! ? Colors.white : Colors.black),
              SizedBox(height: 60, child: VerticalDivider()),
              o1 == null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          o1 = turn;
                          turn = !turn;
                        });
                        checkWin();
                      },
                      icon: SizedBox(width: 40),
                    )
                  : CoinIcon(color: o1! ? Colors.white : Colors.black),
              SizedBox(height: 60, child: VerticalDivider()),
              o2 == null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          o2 = turn;
                          turn = !turn;
                        });
                        checkWin();
                      },
                      icon: SizedBox(width: 40),
                    )
                  : CoinIcon(color: o2! ? Colors.white : Colors.black),
            ],
          ),
          Divider(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              i0 == null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          i0 = turn;
                          turn = !turn;
                        });
                        checkWin();
                      },
                      icon: SizedBox(width: 40),
                    )
                  : CoinIcon(color: i0! ? Colors.white : Colors.black),
              SizedBox(height: 60, child: VerticalDivider()),
              i1 == null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          i1 = turn;
                          turn = !turn;
                        });
                        checkWin();
                      },
                      icon: SizedBox(width: 40),
                    )
                  : CoinIcon(color: i1! ? Colors.white : Colors.black),
              SizedBox(height: 60, child: VerticalDivider()),
              i2 == null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          i2 = turn;
                          turn = !turn;
                        });
                        checkWin();
                      },
                      icon: SizedBox(width: 40),
                    )
                  : CoinIcon(color: i2! ? Colors.white : Colors.black),
            ],
          ),
          Divider(),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              t0 == null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          t0 = turn;
                          turn = !turn;
                        });
                        checkWin();
                      },
                      icon: SizedBox(width: 40),
                    )
                  : CoinIcon(color: t0! ? Colors.white : Colors.black),
              SizedBox(height: 60, child: VerticalDivider()),
              t1 == null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          t1 = turn;
                          turn = !turn;
                        });
                        checkWin();
                      },
                      icon: SizedBox(width: 40),
                    )
                  : CoinIcon(color: t1! ? Colors.white : Colors.black),
              SizedBox(height: 60, child: VerticalDivider()),
              t2 == null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          t2 = turn;
                          turn = !turn;
                        });
                        checkWin();
                      },
                      icon: SizedBox(width: 40),
                    )
                  : CoinIcon(color: t2! ? Colors.white : Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}
