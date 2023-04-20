import 'package:flutter/material.dart';

class SquareCard extends StatelessWidget {
  const SquareCard({
    Key? key,
    required this.mainText,
    required this.subText,
    required this.handleChangeMinutes,
  }) : super(key: key);

  final String mainText;
  final String subText;
  final VoidCallback handleChangeMinutes;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final size = screenWidth / 4; // 화면 가로 크기의 5분의 1로 크기 계산

    return InkWell(
      onTap: handleChangeMinutes,
      child: Container(
        width: size, // 너비와 높이를 같은 값으로 지정
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              mainText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
              ),
            ),
            Text(
              subText,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
