import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class SudokuTableRecognition extends StatefulWidget {
  @override
  State<SudokuTableRecognition> createState() => _SudokuTableRecognitionState();
}

class _SudokuTableRecognitionState extends State<SudokuTableRecognition> {
  TextRecognizer textRecognizer = google.vision.textRecognizer();

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: _processImage,
              child: Text('Process Image'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _processImage(File(pickedImage.path));
    }
  }

  void _processImage(File imageFile) async {
    if (imageFile == null) {
      return;
    }

    // Load the image file
    final image = InputImage.fromFilePath(imageFile.path);

    try {
      final RecognisedText recognisedText = await textRecognizer.processImage(image);
      if (recognisedText != null && recognisedText.text.isNotEmpty) {
        List<int> numbers = extractNumbersFromText(recognisedText.text);
        // Do something with the extracted numbers
        print(numbers);
      } else {
        print('No text found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<int> extractNumbersFromText(String text) {
    List<int> numbers = [];
    // Implement your logic to extract numbers from the recognized text
    // ...

    return numbers;
  }
}
