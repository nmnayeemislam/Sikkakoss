import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:sikka_kosh/constants/app_constants.dart';
import 'package:sikka_kosh/main.dart';
import 'package:sikka_kosh/services/progress_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Kids Learning App shows splash screen', (tester) async {
    final tempDir = await Directory.systemTemp.createTemp(
      'kids_learning_test_',
    );
    await ProgressService.init(storagePath: tempDir.path);

    await tester.pumpWidget(const KidsLearningApp());

    expect(find.text(AppConstants.appName), findsOneWidget);

    await ProgressService.resetProgress(keepDarkMode: false);
    await Hive.close();
    await tempDir.delete(recursive: true);
  });
}
