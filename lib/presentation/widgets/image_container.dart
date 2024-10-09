import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  ImageContainer({super.key, required this.image, this.child});
  final String image;
  Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 90),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black
                .withOpacity(0.3), // Adjust opacity to control darkness
            BlendMode.srcATop, // Blend mode for applying the color filter
          ),

        ),

      ),

      child: child,
    );
  }
}
