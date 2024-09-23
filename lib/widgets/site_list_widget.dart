import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winplant/model/site.dart';
import 'package:winplant/widgets/site_preview_widget.dart';
import 'package:winplant/model/dummy_data.dart' as dummy;

class SiteListWidget extends StatelessWidget {
  const SiteListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchAllSites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var sitePreviews = snapshot.data
                ?.map((site) => SitePreviewWidget(site: site))
                .toList();
            return _buildSiteList(sitePreviews!);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<List<Site>> _fetchAllSites() async {
    return dummy.allSites();
  }

  Widget _buildSiteList(List<SitePreviewWidget> sitePreviews) {
    return Column(children: <Widget>[
      Flexible(
        flex: 3,
        child: ListView(children: sitePreviews),
      ),
      const Spacer(),
      const Padding(
          padding: EdgeInsets.only(left: 200),
          child: Icon(
            Icons.add_circle_rounded,
            size: 70,
            color: Colors.green,
          ))
    ]);
  }
}
