// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

// class SlidableCard extends StatelessWidget {
//   final Widget child;

//   const SlidableCard({required this.child, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Slidable(
//       key: UniqueKey(),
//       endActionPane: ActionPane(
//         motion: ScrollMotion(),
//         children: [
//           SlidableAction(
//             onPressed: (context) {
//               // aksi misal hapus post
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Deleted!")),
//               );
//             },
//             backgroundColor: Colors.red,
//             foregroundColor: Colors.white,
//             icon: Icons.delete,
//             label: 'Delete',
//           ),
//           SlidableAction(
//             onPressed: (context) {
//               // aksi misal report
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Reported!")),
//               );
//             },
//             backgroundColor: Colors.orange,
//             foregroundColor: Colors.white,
//             icon: Icons.report,
//             label: 'Report',
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }

import 'package:flutter/material.dart';

class SwipeableStack extends StatefulWidget {
  final List<Widget> cards;

  SwipeableStack({required this.cards});

  @override
  _SwipeableStackState createState() => _SwipeableStackState();
}

class _SwipeableStackState extends State<SwipeableStack> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  Offset cardOffset = Offset.zero;
  late Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Stack(
      children: List.generate(widget.cards.length, (index) {
        if (index < currentIndex) {
          return Container(); // sudah ter-swipe, tidak ditampilkan
        } else if (index == currentIndex) {
          // kartu teratas yang bisa di-swipe
          return Positioned(
            top: 20.0 + (index - currentIndex) * 10,
            left: 20.0 + (index - currentIndex) * 10,
            right: 20.0 + (index - currentIndex) * 10,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  cardOffset += details.delta;
                });
              },
              onPanEnd: (details) {
                if (cardOffset.dx.abs() > screenSize.width * 0.3) {
                  // swipe ke kiri atau kanan berhasil
                  setState(() {
                    currentIndex++;
                    cardOffset = Offset.zero;
                  });
                } else {
                  // kembali ke posisi awal
                  setState(() {
                    cardOffset = Offset.zero;
                  });
                }
              },
              child: Transform.translate(
                offset: cardOffset,
                child: widget.cards[index],
              ),
            ),
          );
        } else {
          // kartu-kartu di bawahnya, hanya tumpukan statis
          return Positioned(
            top: 20.0 + (index - currentIndex) * 10,
            left: 20.0 + (index - currentIndex) * 10,
            right: 20.0 + (index - currentIndex) * 10,
            child: widget.cards[index],
          );
        }
      }),
    );
  }
}
