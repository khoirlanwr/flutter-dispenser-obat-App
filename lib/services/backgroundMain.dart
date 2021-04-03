import 'package:flutter/cupertino.dart';

import 'counter_service.dart';

void backgroundMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  CounterService.instance().startCounting();
}
