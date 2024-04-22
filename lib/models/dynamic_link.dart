import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

class DynamicLinkProvider {
  // create the link
  //
  Future<String> createLink(String refCode) async {
    final String url = "https://com.example.secretsanta?ref=$refCode";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        androidParameters: const AndroidParameters(
            packageName: "com.example.secretsanta", minimumVersion: 0),
        iosParameters: const IOSParameters(
            bundleId: "com.example.secretsanta", minimumVersion: "0"),
        link: Uri.parse(url),
        uriPrefix: "https://festiveexchange.page.link");

    final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;

    final refLink = await link.buildShortLink(parameters);

    return refLink.shortUrl.toString();
  }

  //Init dynamic link
  void initDynamicLink() async {
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (instanceLink != null) {
      final Uri refLink = instanceLink.link;

      Share.share(("This is the link ${refLink.data}"));
    }
  }
}
