//
// import 'dart:async';
// import 'package:flutter/material.dart';
//
//
// class OCRPage extends StatefulWidget {
//   @override
//   _OCRPageState createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> {
//
//   int OCR_CAM = FlutterMobileVision.CAMERA_BACK;
//   String word = "TEXT";
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white70,
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             title: const Text('Real time OCR'),
//             centerTitle: true,
//           ),
//           body: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _read,
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith<Color?>(
//                           (Set<MaterialState> states) {
//                         if (states.contains(MaterialState.pressed)) {
//                           return Colors.red.shade200; // Color when button is pressed
//                         }
//                         return Colors.red; // Default color
//                       },
//                     ),
//                   ),
//                   child: Text(
//                     'Start Scanning',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//
//               ),
//             ],
//           ),
//       ),
//     );
//   }
//
//   Future<Null> _read() async {
//     List<OcrText> words = [];
//     try {
//       words = await FlutterMobileVision.read(
//         camera: OCR_CAM,
//         waitTap: true,
//       );
//
//       setState(() {
//         word = words[0].value;
//       });
//     } on Exception {
//       words.add( OcrText('Unable to recognize the word'));
//     }
//   }
// }
