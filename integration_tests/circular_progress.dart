import 'package:flutter/material.dart';
import 'package:winplant/widgets/loading_image.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: LoadingImageWidget(
          url: Uri.parse('https://example.com/image.jpg'),
          width: 200,
          height: 200,
        ),
      ),
    ),
  );
}
