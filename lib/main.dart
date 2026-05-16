import 'package:flutter/cupertino.dart';

import 'app.dart';
import 'di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  runApp(const MyApp());
}

