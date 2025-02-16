import 'package:flutter/material.dart';

class LoadingImageWidget extends StatelessWidget {
  final Uri url;

  const LoadingImageWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    var image = Image.network(url.path);
    return image;
  }
}
