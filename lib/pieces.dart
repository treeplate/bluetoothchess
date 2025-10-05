import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

Widget pieceWidget(Piece piece, double size, [Color? overrideColor]) {
  switch (piece.role) {
    case Role.pawn:
      return Pawn(
        color:
            overrideColor ??
            (piece.color == Side.white ? Colors.white : Colors.black),
      );
    case Role.knight:
      return CoinIcon(
        width: size,
        height: size,
        color:
            overrideColor ??
            (piece.color == Side.white ? Colors.white : Colors.black),
      );
    case Role.bishop:
      return Bishop(
        color:
            overrideColor ??
            (piece.color == Side.white ? Colors.white : Colors.black),
      );
    case Role.rook:
      return Rook(
        color:
            overrideColor ??
            (piece.color == Side.white ? Colors.white : Colors.black),
      );
    case Role.king:
      return King(
        color:
            overrideColor ??
            (piece.color == Side.white ? Colors.white : Colors.black),
      );
    case Role.queen:
      return Queen(
        color:
            overrideColor ??
            (piece.color == Side.white ? Colors.white : Colors.black),
      );
  }
}

class RenderPawn extends RenderBox {
  RenderPawn({required this.color});
  Color color;
  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    print(constraints.biggest);
    return constraints.biggest;
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Path path = Path();
    path.moveTo(offset.dx + size.width / 2, offset.dy + size.height / 3);
    path.quadraticBezierTo(
      offset.dx + size.width * 4 / 6,
      offset.dy + size.height / 3,
      offset.dx + size.width * 4 / 6,
      offset.dy + size.height * 2 / 3,
    );
    path.quadraticBezierTo(
      offset.dx + size.width * 5 / 6,
      offset.dy + size.height * 2 / 3,
      offset.dx + size.width * 5 / 6,
      offset.dy + size.height,
    );
    path.lineTo(offset.dx + size.width / 6, offset.dy + size.height);
    path.quadraticBezierTo(
      offset.dx + size.width / 6,
      offset.dy + size.height * 2 / 3,
      offset.dx + size.width * 2 / 6,
      offset.dy + size.height * 2 / 3,
    );
    path.quadraticBezierTo(
      offset.dx + size.width * 2 / 6,
      offset.dy + size.height / 3,
      offset.dx + size.width / 2,
      offset.dy + size.height / 3,
    );
    context.canvas.drawPath(path, Paint()..color = color);
  }
}

class Pawn extends LeafRenderObjectWidget {
  const Pawn({super.key, required this.color});
  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPawn(color: color);
  }

  @override
  void updateRenderObject(BuildContext context, RenderPawn renderObject) {
    renderObject.color = color;
  }
}

class RenderRook extends RenderBox {
  RenderRook({required this.color});
  Color color;
  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Path path = Path();
    path.moveTo(offset.dx + size.width * 3 / 7, offset.dy + size.height / 4);
    path.lineTo(offset.dx + size.width * 4 / 7, offset.dy + size.height / 4);
    path.lineTo(
      offset.dx + size.width * 4 / 7,
      offset.dy + size.height * 2 / 4,
    );
    path.lineTo(
      offset.dx + size.width * 5 / 7,
      offset.dy + size.height * 2 / 4,
    );
    path.lineTo(offset.dx + size.width * 5 / 7, offset.dy + size.height / 4);
    path.lineTo(offset.dx + size.width * 6 / 7, offset.dy + size.height / 4);
    path.lineTo(offset.dx + size.width * 6 / 7, offset.dy + size.height);
    path.lineTo(offset.dx + size.width * 1 / 7, offset.dy + size.height);
    path.lineTo(offset.dx + size.width * 1 / 7, offset.dy + size.height / 4);
    path.lineTo(offset.dx + size.width * 2 / 7, offset.dy + size.height / 4);
    path.lineTo(
      offset.dx + size.width * 2 / 7,
      offset.dy + size.height * 2 / 4,
    );
    path.lineTo(
      offset.dx + size.width * 3 / 7,
      offset.dy + size.height * 2 / 4,
    );
    context.canvas.drawPath(path, Paint()..color = color);
  }
}

class Rook extends LeafRenderObjectWidget {
  const Rook({super.key, required this.color});
  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRook(color: color);
  }

  @override
  void updateRenderObject(BuildContext context, RenderRook renderObject) {
    renderObject.color = color;
  }
}

class RenderBishop extends RenderBox {
  RenderBishop({required this.color});
  Color color;
  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Path path = Path();
    path.moveTo(offset.dx + size.width * 11 / 24, offset.dy + size.height / 3);
    path.lineTo(offset.dx + size.width * 11 / 24, offset.dy + size.height / 2);
    path.lineTo(offset.dx + size.width * 13 / 24, offset.dy + size.height / 2);
    path.lineTo(offset.dx + size.width * 13 / 24, offset.dy + size.height / 3);
    path.quadraticBezierTo(
      offset.dx + size.width * 4 / 6,
      offset.dy + size.height / 3,
      offset.dx + size.width * 4 / 6,
      offset.dy + size.height * 2 / 3,
    );
    path.quadraticBezierTo(
      offset.dx + size.width * 5 / 6,
      offset.dy + size.height * 2 / 3,
      offset.dx + size.width * 5 / 6,
      offset.dy + size.height,
    );
    path.lineTo(offset.dx + size.width / 6, offset.dy + size.height);
    path.quadraticBezierTo(
      offset.dx + size.width / 6,
      offset.dy + size.height * 2 / 3,
      offset.dx + size.width * 2 / 6,
      offset.dy + size.height * 2 / 3,
    );
    path.quadraticBezierTo(
      offset.dx + size.width * 2 / 6,
      offset.dy + size.height / 3,
      offset.dx + size.width / 2,
      offset.dy + size.height / 3,
    );
    context.canvas.drawPath(path, Paint()..color = color);
  }
}

class Bishop extends LeafRenderObjectWidget {
  const Bishop({super.key, required this.color});
  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderBishop(color: color);
  }

  @override
  void updateRenderObject(BuildContext context, RenderBishop renderObject) {
    renderObject.color = color;
  }
}

class RenderQueen extends RenderBox {
  RenderQueen({required this.color});
  Color color;
  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Path path = Path();
    path.moveTo(offset.dx + size.width * 3 / 7, offset.dy + size.height / 4);
    path.lineTo(offset.dx + size.width * 4 / 7, offset.dy + size.height / 4);
    path.lineTo(
      offset.dx + size.width * 4 / 7,
      offset.dy + size.height * 2 / 4,
    );
    path.lineTo(
      offset.dx + size.width * 5 / 7,
      offset.dy + size.height * 2 / 4,
    );
    path.lineTo(offset.dx + size.width * 5 / 7, offset.dy + size.height / 4);
    path.lineTo(offset.dx + size.width * 6 / 7, offset.dy + size.height / 4);
    path.lineTo(offset.dx + size.width * 6 / 7, offset.dy + size.height);
    path.lineTo(offset.dx + size.width * 1 / 7, offset.dy + size.height);
    path.lineTo(offset.dx + size.width * 1 / 7, offset.dy + size.height / 4);
    path.lineTo(offset.dx + size.width * 2 / 7, offset.dy + size.height / 4);
    path.lineTo(
      offset.dx + size.width * 2 / 7,
      offset.dy + size.height * 2 / 4,
    );
    path.lineTo(
      offset.dx + size.width * 3 / 7,
      offset.dy + size.height * 2 / 4,
    );
    context.canvas.drawPath(path, Paint()..color = color.withAlpha(128));
    path = Path();
    path.moveTo(offset.dx + size.width * 11 / 24, offset.dy + size.height / 3);
    path.lineTo(offset.dx + size.width * 11 / 24, offset.dy + size.height / 2);
    path.lineTo(offset.dx + size.width * 13 / 24, offset.dy + size.height / 2);
    path.lineTo(offset.dx + size.width * 13 / 24, offset.dy + size.height / 3);
    path.quadraticBezierTo(
      offset.dx + size.width * 4 / 6,
      offset.dy + size.height / 3,
      offset.dx + size.width * 4 / 6,
      offset.dy + size.height * 2 / 3,
    );
    path.quadraticBezierTo(
      offset.dx + size.width * 5 / 6,
      offset.dy + size.height * 2 / 3,
      offset.dx + size.width * 5 / 6,
      offset.dy + size.height,
    );
    path.lineTo(offset.dx + size.width / 6, offset.dy + size.height);
    path.quadraticBezierTo(
      offset.dx + size.width / 6,
      offset.dy + size.height * 2 / 3,
      offset.dx + size.width * 2 / 6,
      offset.dy + size.height * 2 / 3,
    );
    path.quadraticBezierTo(
      offset.dx + size.width * 2 / 6,
      offset.dy + size.height / 3,
      offset.dx + size.width / 2,
      offset.dy + size.height / 3,
    );
    context.canvas.drawPath(path, Paint()..color = color.withAlpha(128));
  }
}

class Queen extends LeafRenderObjectWidget {
  const Queen({super.key, required this.color});
  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderQueen(color: color);
  }

  @override
  void updateRenderObject(BuildContext context, RenderQueen renderObject) {
    renderObject.color = color;
  }
}

class RenderKing extends RenderBox {
  RenderKing({required this.color});
  Color color;
  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Path path = Path();
    path.moveTo(offset.dx + size.width / 7, offset.dy + size.height);
    path.lineTo(offset.dx + size.width * 3 / 14, offset.dy + size.height / 4);
    path.lineTo(
      offset.dx + size.width * 5 / 14,
      offset.dy + size.height * 3 / 4,
    );
    path.lineTo(offset.dx + size.width * 7 / 14, offset.dy + size.height / 4);
    path.lineTo(
      offset.dx + size.width * 9 / 14,
      offset.dy + size.height * 3 / 4,
    );
    path.lineTo(offset.dx + size.width * 11 / 14, offset.dy + size.height / 4);
    path.lineTo(offset.dx + size.width * 12 / 14, offset.dy + size.height);
    context.canvas.drawPath(path, Paint()..color = color);
  }
}

class King extends LeafRenderObjectWidget {
  const King({super.key, required this.color});
  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderKing(color: color);
  }

  @override
  void updateRenderObject(BuildContext context, RenderKing renderObject) {
    renderObject.color = color;
  }
}

class CoinIcon extends StatelessWidget {
  const CoinIcon({
    super.key,
    this.color = Colors.yellow,
    this.width = 56,
    this.height = 56,
  });
  final Color? color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(width / 7, height / 4, width / 7, 0),
      child: Container(
        width: width * 5 / 7,
        height: height * 5 / 7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.orangeAccent,
            ),
            width: (width * 5 / 7) * 3 / 4,
            height: (height * 5 / 7) * 3 / 4,
            child: Center(
              child: Text(
                'N',
                style: TextStyle(
                  fontSize: (width * 5 / 7) / 2,
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
