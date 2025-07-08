import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  final String image;
  final String step;
  final List<TextSpan> styledText;
  final Color backgroundColor;

  const OnboardingWidget({
    super.key,
    required this.image,
    required this.step,
    required this.styledText,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        
        Container(
          width: screenWidth,
          height: screenHeight * 0.5,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),  

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8), 
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                step,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 20),

          
            SizedBox(
              width: screenWidth * 0.9,  
              height: screenHeight * 0.37,  
              child: Image.asset(image, fit: BoxFit.contain),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 26, 
                    fontWeight: FontWeight.bold,
                  ),
                  children: styledText,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
