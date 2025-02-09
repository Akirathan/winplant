
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:winplant/model/history.dart';
import 'package:winplant/model/plant_info.dart';

/// A plant that is planted in the user's garden.
/// A mutable version of [PlantInfo].
/// TODO: This is deprecated in favor of garden_plant_model
class Plant {
  final PlantInfo info;
  final TimeLine timeLine;
  /// User-given name of the plant.
  String? name;
  /// Main user-given photo (image) of the plant.
  /// If the user does not set their photo, let's display the photo
  /// from [PlantInfo].
  AssetImage? image;

  Plant({required this.info, required this.timeLine});
}
