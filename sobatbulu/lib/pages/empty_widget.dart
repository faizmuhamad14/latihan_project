import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyPetWidget extends StatelessWidget {
  const EmptyPetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset("assets/lottie/addPet.json", height: 250),
        Text("Kamu belum menambahkan Pet apapun"),
      ],
    );
  }
}
