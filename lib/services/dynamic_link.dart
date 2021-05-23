import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLink {
  HubRootData hubRootData = HubRootData();
  Future<Uri> createDynamicLink(String hubCode, String hubName) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: "http://classscheduler.page.link",
        // &apn=package_name
        link: Uri.parse(
            "http://classscheduler.page.link/joinHub?hubName=$hubName&hubCode =$hubCode"),
        androidParameters: AndroidParameters(
          packageName: "com.example.classroom_scheduler_flutter",
          minimumVersion: 0,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: "class scheduler ",
        ));

    var dynamicUrl = await parameters.buildUrl();
    return dynamicUrl;
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        handleDynamicLink(deepLink, context);
        // handleDynamicLink(data);
//         print('downloaded using link');
//         print(deepLink.pathSegments);
// // implemnt hub joining extracting hubcode from deeplink
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => LandingPage()));
      }

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        AppLogger.print('opened from link');
        handleDynamicLink(dynamicLink?.link, context);

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LandingPage()));
      });
    } catch (e) {
      print(e.toString());
    }
  }

  handleDynamicLink(Uri data, BuildContext context) async {
    final hubName = data.queryParameters.values.first;
    final hubCode = data.queryParameters.values.last;
    AppLogger.print(hubName);
    AppLogger.print(hubCode);
    final token = 'poiugfdgcvhjkhfdsazdxfcvhcxzd';
    if (hubName != null && hubCode != null) {
      hubRootData.joinHub(token, context,
          hubName: hubName, hubCode: hubCode, isRetriving: true);
    }
  }
}
