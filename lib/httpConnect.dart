import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:device_info/device_info.dart';

void main() {
  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor;
  }

  print(getDeviceId());
}

void httpConnect() async {
  final header = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  final body = json.encode({'name': 'hoge', 'age': 16});

  final uri = Uri.http('minami.jn.sfc.keio.ac.jp:80', "/");
  final res = await http.post(
    uri,
    headers: header,
    body: body,
  );
  print(res.body);
}
