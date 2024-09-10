import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

sealed class HistoryEntry extends StatelessWidget {
  final DateTime date;

  const HistoryEntry({super.key, required this.date});
}

class Watering extends HistoryEntry {
  const Watering({super.key, required super.date});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class Fertilization extends HistoryEntry {
  const Fertilization({super.key, required super.date});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
