
import 'package:winplant/model/history.dart';
import 'package:winplant/model/plant_info.dart';

/// A plant that is planted in the user's garden.
/// A mutable version of [PlantInfo].
class Plant {
  final PlantInfo info;
  final TimeLine timeLine;

  Plant({required this.info, required this.timeLine});
}
