import 'package:aluna/core/routing/routes.dart';
import 'package:aluna/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AISoundAnalysisScreen extends StatefulWidget {
  const AISoundAnalysisScreen({super.key});

  @override
  _AISoundAnalysisScreenState createState() => _AISoundAnalysisScreenState();
}

class _AISoundAnalysisScreenState extends State<AISoundAnalysisScreen>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  double _waveScale = 1.0;
  late AnimationController _animationController;
  String _spokenText = "";

  final List<String> targetWords = [
    "I",
    "believe",
    "in",
    "luna",
    "with",
    "all",
    "my",
    "heart."
  ];
  List<bool> wordStatus = List.filled(9, false); // Tracks spoken words

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 1.0,
      upperBound: 1.5,
    )..addListener(() {
        setState(() {
          _waveScale = _animationController.value;
        });
      });
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'listening') {
          setState(() {
            _isListening = true;
          });
          _animationController.repeat(reverse: true);
        } else if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
          });
          _animationController.stop();
          _animationController.value = 1.0;
        }
      },
      onError: (error) {
        print('Speech Error: $error');
      },
    );

    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords;
            _updateWordStatus();
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
    _animationController.stop();
    _animationController.value = 1.0;
  }

  void _updateWordStatus() {
    List<String> spokenWords = _spokenText.split(" ");
    for (int i = 0; i < targetWords.length; i++) {
      if (i < spokenWords.length &&
          spokenWords[i].toLowerCase() == targetWords[i].toLowerCase()) {
        wordStatus[i] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F2),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black54),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "Assessment",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorStyles.fontMainColor,
                  ),
                ),
                SizedBox(
                  width: 50.w,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: ColorStyles.mainColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "13 of 13",
                    style: TextStyle(
                        color: ColorStyles.backgroundColor, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "AI Sound Analysis",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: ColorStyles.fontMainColor,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please say the following words below. Don't worry, we don’t steal your voice data.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: ColorStyles.fontSmallBoldColor),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _isListening ? _stopListening : _startListening,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 200 * _waveScale,
                height: 200 * _waveScale,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFA8DAD3),
                ),
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF88D1C7),
                    ),
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF3A8A81),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: List.generate(targetWords.length, (index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: wordStatus[index]
                        ? const Color(0xFF3A8A81)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    targetWords[index],
                    style: TextStyle(
                      fontSize: 18,
                      color: wordStatus[index]
                          ? Colors.white
                          : ColorStyles.fontMainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyles.mainColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.homeScreen);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Continue",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
