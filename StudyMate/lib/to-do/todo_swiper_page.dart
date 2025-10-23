import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class Example extends StatelessWidget {
  Example({super.key});

  final List<Widget> cards = [
    Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '1',
        style: TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '2',
        style: TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '3',
        style: TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Card Swiper Example'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: SizedBox(
          height: 500,
          width: 350,
          child: CardSwiper(
            cardsCount: cards.length,
            cardBuilder: (context, index, percentX, percentY) => cards[index],
            isLoop: false,
            allowedSwipeDirection:
                const AllowedSwipeDirection.symmetric(horizontal: true, vertical: false),
          ),
        ),
      ),
    );
  }
}
