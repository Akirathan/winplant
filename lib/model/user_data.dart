import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winplant/model/site_model.dart';

const userDataPath = 'user-data';

/// Model of an authenticated user
class UserData {
  final String id;
  final List<String> siteIds;
  late List<SiteModel>? _sites;

  UserData({required this.id, required this.siteIds});

  Future<List<SiteModel>> get sites async {
    if (_sites == null) {
      List<SiteModel> sites = List.empty(growable: true);
      for (var siteId in siteIds) {
        var site = await SiteModel.fetch(siteId);
        sites.add(site!);
      }
      _sites = sites;
    }
    return _sites!;
  }

  static Future<UserData> fetch(String userId) async {
    var db = FirebaseFirestore.instance;
    var userDoc = await db.collection(userDataPath).doc(userId).get();
    var userData = userDoc.data()!;
    var sites = userData['sites'] as List<String>;
    return UserData(id: userId, siteIds: sites);
  }
}
