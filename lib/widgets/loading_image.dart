import 'package:flutter/material.dart';

class LoadingImageWidget extends StatefulWidget {
  final Uri url;

  const LoadingImageWidget({super.key, required this.url});

  @override
  State<StatefulWidget> createState() => _LoadingImageWidgetState();
}

class _LoadingImageWidgetState extends State<LoadingImageWidget> {
  bool _isFetched;
  late Image _image;

  _LoadingImageWidgetState() : _isFetched = false;

  @override
  void initState() {
    super.initState();
    _image = Image.network(widget.url.toString());
    var imgProvider = _image.image;
    var imgStream = imgProvider.resolve(const ImageConfiguration());
    var listener = ImageStreamListener((imgInfo, _) {
      _isFetched = true;
    });
    imgStream.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetched) {
      return _image;
    } else {
      return const CircularProgressIndicator();
    }
  }
}
