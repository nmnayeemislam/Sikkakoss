import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';
import '../models/progress_summary.dart';

class ProgressService {
  ProgressService._();

  static Box<dynamic>? _box;

  static Future<void> init({String? storagePath}) async {
    if (storagePath == null) {
      await Hive.initFlutter();
    } else {
      Hive.init(storagePath);
    }
    _box = await Hive.openBox<dynamic>(AppConstants.progressBox);
  }

  static Box<dynamic> get _progressBox {
    final box = _box;
    if (box == null) {
      throw StateError('ProgressService.init must be called before use.');
    }
    return box;
  }

  static ProgressSummary getSummary() {
    return ProgressSummary(
      completedLessons: getCompletedLessons(),
      quizScores: getQuizScores(),
      lastOpenedCategory: getLastOpenedCategory(),
      totalStars: getTotalStars(),
      isDarkMode: isDarkMode(),
    );
  }

  static Set<String> getCompletedLessons() {
    final lessons = _progressBox.get(
      AppConstants.completedLessonsKey,
      defaultValue: <String>[],
    );
    return List<String>.from(lessons as List).toSet();
  }

  static Future<void> markLessonComplete(String lessonId) async {
    final lessons = getCompletedLessons()..add(lessonId);
    await _progressBox.put(AppConstants.completedLessonsKey, lessons.toList());
  }

  static List<int> getQuizScores() {
    final scores = _progressBox.get(
      AppConstants.quizScoresKey,
      defaultValue: <int>[],
    );
    return List<int>.from(scores as List);
  }

  static Future<void> saveQuizScore(int score, int stars) async {
    final scores = getQuizScores()..add(score);
    await _progressBox.put(AppConstants.quizScoresKey, scores);
    await addStars(stars);
  }

  static String getLastOpenedCategory() {
    return _progressBox.get(
          AppConstants.lastOpenedCategoryKey,
          defaultValue: '',
        )
        as String;
  }

  static Future<void> setLastOpenedCategory(String category) async {
    await _progressBox.put(AppConstants.lastOpenedCategoryKey, category);
  }

  static int getTotalStars() {
    return _progressBox.get(AppConstants.totalStarsKey, defaultValue: 0) as int;
  }

  static Future<void> addStars(int stars) async {
    await _progressBox.put(AppConstants.totalStarsKey, getTotalStars() + stars);
  }

  static bool isDarkMode() {
    return _progressBox.get(AppConstants.darkModeKey, defaultValue: false)
        as bool;
  }

  static Future<void> setDarkMode(bool value) async {
    await _progressBox.put(AppConstants.darkModeKey, value);
  }

  static Future<void> resetProgress({bool keepDarkMode = true}) async {
    final darkMode = isDarkMode();
    await _progressBox.clear();
    if (keepDarkMode) {
      await setDarkMode(darkMode);
    }
  }
}
