import 'package:flutter/material.dart';
import 'package:winplant/model/plant.dart';

Widget lightWidget(Light light) {
  switch (light) {
    case Light.fullSun:
      return const FullSun();
    case Light.partialSun:
      return const PartialSun();
    case Light.shade:
      throw UnimplementedError("Shade not implemented");
  }
}

Widget difficultyWidget(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return const Easy();
    case Difficulty.medium:
      return const Medium();
    case Difficulty.hard:
      return const Hard();
  }
}

Widget waterWidget(Water water) {
  switch (water) {
    case Water.fullWater:
      return const FullWater();
    case Water.lowWater:
      return const LowWater();
  }
}

Widget _tag(Icon icon, String text) {
  return Row(
    children: [
      Flexible(
          flex: 2,
          child: icon
      ),
      Flexible(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 8,
                overflow: TextOverflow.ellipsis
            ),
          )
      )
    ],
  );
}

sealed class LightWidget extends StatelessWidget {
  const LightWidget({super.key});
}

class FullSun extends LightWidget {
  const FullSun({super.key});

  @override
  Widget build(BuildContext context) {
    return _tag(
        const Icon(Icons.wb_sunny, color: Colors.amber),
        'Full Sun'
    );
  }
}


class PartialSun extends LightWidget {
  const PartialSun({super.key});

  @override
  Widget build(BuildContext context) {
    return _tag(
      const Icon(Icons.wb_sunny_outlined, color: Colors.amber),
      'Partial Sun'
    );
  }
}

sealed class DifficultyWidget extends StatelessWidget {
  const DifficultyWidget({super.key});
}

class Easy extends DifficultyWidget {
  const Easy({super.key});

  @override
  Widget build(BuildContext context) {
    return _tag(
      const Icon(Icons.star),
      'Easy'
    );
  }
}

class Medium extends DifficultyWidget {
  const Medium({super.key});

  @override
  Widget build(BuildContext context) {
    return _tag(
      const Icon(Icons.star_half),
      'Medium'
    );
  }
}

class Hard extends DifficultyWidget {
  const Hard({super.key});

  @override
  Widget build(BuildContext context) {
    return _tag(
        const Icon(Icons.star_border),
        'Hard'
    );
  }
}

sealed class WaterWidget extends StatelessWidget {
  const WaterWidget({super.key});
}

class FullWater extends WaterWidget {
  const FullWater({super.key});

  @override
  Widget build(BuildContext context) {
    return _tag(
      const Icon(Icons.water_drop, color: Colors.blue),
      'A lot of water'
    );
  }
}

class LowWater extends WaterWidget {
  const LowWater({super.key});

  @override
  Widget build(BuildContext context) {
    return _tag(
      const Icon(Icons.water_drop_outlined),
      'Low water'
    );
  }
}
