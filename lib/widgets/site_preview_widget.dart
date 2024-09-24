import 'package:flutter/material.dart';
import 'package:winplant/model/site.dart';
import 'package:winplant/routes.dart';
import 'package:winplant/widgets/tags.dart';

class SitePreviewWidget extends StatelessWidget {
  final Site site;

  const SitePreviewWidget({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey, width: 2, style: BorderStyle.solid)),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 200,
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Image(
                  image: site.image,
                ),
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Flexible(
                        flex: 2,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, siteRoute,
                                  arguments: site);
                            },
                            child: Text(site.name,
                                style: const TextStyle(fontSize: 17)))),
                    const Spacer(),
                    Flexible(fit: FlexFit.loose, child: lightWidget(site.light))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
