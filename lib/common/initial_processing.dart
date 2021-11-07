import 'package:hukaborimemo/common/model/database/db_provider.dart';
import 'package:hukaborimemo/common/model/database/tables.dart';
import 'package:hukaborimemo/setting/prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialProcessing {

  static const List<String> initialTagList = [
    'なぜ？',
    'なにを？',
    'どこで？',
    'いつ？',
    'どのように？',
    'だれが？'
  ];

  static Future<void> function() async {

    final prefs = await SharedPreferences.getInstance();
    final firstRun = prefs.getBool(PrefsKeys.firstRun) ?? true;

    if (firstRun) {

      final now = DateTime.now().toString();
      for (int i = 0; i < initialTagList.length; i++) {
        final TagTable tagTable = TagTable(
            id: null,
            name: initialTagList[i],
            usedAt: now,
            createdAt: now,
            updatedAt: now);
        await Future.wait([DBProvider.db.insertTagData(tagTable)]);
      }

      prefs.setBool(PrefsKeys.firstRun, false);

    }
  }

}
