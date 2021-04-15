import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLink {
  Future<Uri> createDynamicLink(String hubCode, String hubName) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: "http://classscheduler.page.link",
        link: Uri.parse("http://classscheduler.page.link/$hubName/$hubCode"),
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
        print('---------------------------');
        print(deepLink.pathSegments);
// implemnt hub joining extracting hubcode from deeplink
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LandingPage()));
      }

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        print('---------------------------on');
        print(deepLink.data);
// implemnt hub joining extracting hubcode from deeplink
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LandingPage()));
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Future handleDynamicLinks() async {
  //   final PendingDynamicLinkData data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   handleDeepLink(data);
  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData dynamicLinkData) async {},
  //       onError: (OnLinkErrorException e) async {
  //         print("dynamic link fails : $e");
  //       });
  // }

  // void handleDeepLink(PendingDynamicLinkData data) {
  //   final Uri deepLink = data?.link;
  //   if (deepLink != null) {
  //     print("----------------------------------------------------");
  //     print("handkeeeee : $deepLink");
  //   }
  // }
}
