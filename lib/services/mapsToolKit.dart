import 'package:maps_toolkit/maps_toolkit.dart';

class MapsToolKit {
  static double getMarkerRotaion(sLat, sLang, dLat, dLang) {
    var rot =
        SphericalUtil.computeHeading(LatLng(sLat, sLang), LatLng(dLat, dLang));
    return rot;
  }
}
