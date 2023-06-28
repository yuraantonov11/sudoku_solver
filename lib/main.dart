import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:image/image.dart' as img;
import 'package:image_editor/image_editor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Grid Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  List<Offset> _sudokuGridCorners = [];
  ui.Image? _uiImage;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    if (_imageFile != null) {
      final imageBytes = await _imageFile!.readAsBytes();
      final completer = Completer<ui.Image>();
      ui.decodeImageFromList(imageBytes, (ui.Image img) {
        setState(() {
          _uiImage = img;
        });
        completer.complete(img);
      });

      // Create an Image widget from the ui.Image
      return;
    }
    throw Exception('Failed to load image');
  }

  Future<void> _pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        _sudokuGridCorners = [];
        _uiImage = null;
      });
      await loadImage();
    }
  }


  List<Offset> calculateSudokuGridCorners() {
    // Calculate the sudoku grid corners
    // ...

    return [];
  }

  Future<void> _processImage() async {
    if (_imageFile == null) {
      return;
    }

    // Check the format of the image file
    final imageExtension = _imageFile!.path.split('.').last;
    if (!['png', 'jpeg', 'webp'].contains(imageExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image file must be in PNG, JPEG, or WebP format'),
        ),
      );
      return;
    }

    // Check the size of the image file
    final imageSize = await _imageFile!.length();
    if (imageSize > 100 * 1024 * 1024) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image file must be less than 100MB'),
        ),
      );
      return;
    }

    // Read the image file
    final imageBytes = await _imageFile!.readAsBytes();
    final image = img.decodeImage(imageBytes);

    // Convert the image to grayscale
    final grayImage = img.grayscale(image!);

    // Detect cells on the grayscale image
    detectCells(grayImage);

    setState(() {
      _sudokuGridCorners = calculateSudokuGridCorners(); // Update the value of sudokuGridCorners
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku Grid Detection'),
      ),
      body: Column(
        children: [
          if (_imageFile != null && _uiImage != null)
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: _uiImage!.width.toDouble(),
                  height: _uiImage!.height.toDouble(),
                  child: CustomPaint(
                    painter: SudokuGridPainter(
                      uiImage: _uiImage!,
                      gridCorners: _sudokuGridCorners,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          if (_imageFile == null || _sudokuGridCorners.isEmpty)
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
          if (_imageFile != null && _sudokuGridCorners.isEmpty)
            ElevatedButton(
              onPressed: _processImage,
              child: const Text('Process Image'),
            ),
        ],
      ),
    );
  }
}

List<img.Image> detectCells(img.Image image) {
  // Конвертувати зображення у відтінки сірого
  var grayImage = img.grayscale(image);

  // Бінаризація зображення (перетворення на чорно-біле зображення)
  var binaryImage = img.threshold(grayImage, 127);

  // Застосувати алгоритм виявлення контурів
  var contours = binaryImage.findContours();

  // Фільтрація контурів, що відповідають розмірам ячейок Судоку
  var filteredContours = contours.where((contour) {
    var boundingBox = contour.boundingBox();
    var width = boundingBox.width;
    var height = boundingBox.height;
    // Задайте діапазон розмірів ячейок, які потрібно розпізнати
    var minCellSize = 30;
    var maxCellSize = 100;
    return width >= minCellSize &&
        width <= maxCellSize &&
        height >= minCellSize &&
        height <= maxCellSize;
  }).toList();

  // Виділення ячейок із зображення та повернення списку знайдених зображень ячейок
  var cells = <img.Image>[];
  for (var contour in filteredContours) {
    var boundingBox = contour.boundingBox();
    var cellImage = binaryImage.crop(boundingBox.left, boundingBox.top, boundingBox.width, boundingBox.height);
    cells.add(cellImage);
  }

  return cells;
}


class SudokuGridPainter extends CustomPainter {
  final ui.Image uiImage;
  final List<Offset> gridCorners;

  SudokuGridPainter({required this.uiImage, required this.gridCorners});

  @override
  void paint(Canvas canvas, Size size) {
    final imageRect = Offset.zero & size;

    canvas.drawImageRect(
      uiImage,
      imageRect,
      imageRect,
      Paint(),
    );

    if (gridCorners.length == 4) {
      final gridPaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final path = Path();
      path.moveTo(gridCorners[0].dx, gridCorners[0].dy);
      for (int i = 1; i < gridCorners.length; i++) {
        path.lineTo(gridCorners[i].dx, gridCorners[i].dy);
      }
      path.close();

      canvas.drawPath(path, gridPaint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
