import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class InputSection extends StatefulWidget {
  final Function(String) onTextChanged;

  const InputSection({super.key, required this.onTextChanged});

  @override
  _InputSectionState createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Field
          TextField(
            decoration: InputDecoration(
              hintText: "Title ...",
              filled: true,
              fillColor: ColorStyles.mainColor.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Notes Field
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Add some notes ...",
              filled: true,
              fillColor: ColorStyles.mainColor.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: widget.onTextChanged, // Send data to parent widget
          ),
        ],
      ),
    );
  }
}
