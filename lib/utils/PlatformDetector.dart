import 'package:universal_platform/universal_platform.dart';

class PlatformDetector {

  bool isAndroid() => UniversalPlatform.isAndroid;
  bool isIOS() => UniversalPlatform.isIOS;
  bool isWeb() => UniversalPlatform.isWeb;
  bool isWindows() => UniversalPlatform.isWindows;
  bool isMacOS() => UniversalPlatform.isMacOS;
  bool isLinux() => UniversalPlatform.isLinux;
  bool isFuchsia() => UniversalPlatform.isFuchsia;
}