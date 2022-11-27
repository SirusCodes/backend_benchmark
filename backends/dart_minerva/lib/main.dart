import 'package:minerva/minerva.dart';

import 'builders/setting_builder.dart';

void main(List<String> args) async {
  // Bind server
  await Minerva.bind(args: args, settingBuilder: SettingBuilder());
}
