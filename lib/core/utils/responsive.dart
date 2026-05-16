import 'package:flutter/cupertino.dart';

class Responsive {
  final BuildContext context;
  Responsive(this.context);

  Size get size => MediaQuery.of(context).size;
  double get width => size.width;
  double get height => size.height;

  bool get isPhone => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;

  double get padding => isPhone ? 20 : (isTablet ? 32 : 48);
  double get maxContentWidth => isDesktop ? 600 : double.infinity;

  double scale(double phone, [double? tablet, double? desktop]) {
    if (isDesktop) return desktop ?? tablet ?? phone;
    if (isTablet) return tablet ?? phone;
    return phone;
  }
}

extension ResponsiveExt on BuildContext {
  Responsive get r => Responsive(this);
}
