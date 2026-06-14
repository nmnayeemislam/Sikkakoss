import '../models/learning_item.dart';
import '../models/surah.dart';

class AudioAssets {
  const AudioAssets._();

  static const Map<String, String> _banglaVowelPaths = {
    'অ': 'audio/bangla/aw.mp3',
    'আ': 'audio/bangla/aa.mp3',
    'ই': 'audio/bangla/i.mp3',
    'ঈ': 'audio/bangla/ii.mp3',
    'উ': 'audio/bangla/u.mp3',
    'ঊ': 'audio/bangla/uu.mp3',
    'ঋ': 'audio/bangla/ri.mp3',
    'এ': 'audio/bangla/e.mp3',
    'ঐ': 'audio/bangla/oi.mp3',
    'ও': 'audio/bangla/o.mp3',
    'ঔ': 'audio/bangla/ou.mp3',
  };

  static const Map<String, String> _banglaConsonantPaths = {
    'ক': 'audio/bangla/ka.mp3',
    'খ': 'audio/bangla/kha.mp3',
    'গ': 'audio/bangla/ga.mp3',
    'ঘ': 'audio/bangla/gha.mp3',
    'ঙ': 'audio/bangla/nga.mp3',
    'চ': 'audio/bangla/ca.mp3',
    'ছ': 'audio/bangla/cha.mp3',
    'জ': 'audio/bangla/ja.mp3',
    'ঝ': 'audio/bangla/jha.mp3',
    'ঞ': 'audio/bangla/nya.mp3',
    'ট': 'audio/bangla/tta.mp3',
    'ঠ': 'audio/bangla/ttha.mp3',
    'ড': 'audio/bangla/dda.mp3',
    'ঢ': 'audio/bangla/ddha.mp3',
    'ণ': 'audio/bangla/nna.mp3',
    'ত': 'audio/bangla/ta.mp3',
    'থ': 'audio/bangla/tha.mp3',
    'দ': 'audio/bangla/da.mp3',
    'ধ': 'audio/bangla/dha.mp3',
    'ন': 'audio/bangla/na.mp3',
    'প': 'audio/bangla/pa.mp3',
    'ফ': 'audio/bangla/pha.mp3',
    'ব': 'audio/bangla/ba.mp3',
    'ভ': 'audio/bangla/bha.mp3',
    'ম': 'audio/bangla/ma.mp3',
    'য': 'audio/bangla/za.mp3',
    'র': 'audio/bangla/ra.mp3',
    'ল': 'audio/bangla/la.mp3',
    'শ': 'audio/bangla/sha.mp3',
    'ষ': 'audio/bangla/ssha.mp3',
    'স': 'audio/bangla/sa.mp3',
    'হ': 'audio/bangla/ha.mp3',
    'ড়': 'audio/bangla/rra.mp3',
    'ঢ়': 'audio/bangla/rha.mp3',
    'য়': 'audio/bangla/ya.mp3',
    'ৎ': 'audio/bangla/tto.mp3',
    'ং': 'audio/bangla/ong.mp3',
    'ঃ': 'audio/bangla/bisarg.mp3',
    'ঁ': 'audio/bangla/chandra.mp3',
  };

  static const Map<String, String> _arabicLetterPaths = {
    'ا': 'audio/arabic/alif.mp3',
    'ب': 'audio/arabic/ba.mp3',
    'ت': 'audio/arabic/ta.mp3',
    'ث': 'audio/arabic/tha.mp3',
    'ج': 'audio/arabic/jeem.mp3',
    'ح': 'audio/arabic/haa.mp3',
    'خ': 'audio/arabic/khaa.mp3',
    'د': 'audio/arabic/dal.mp3',
    'ذ': 'audio/arabic/dhal.mp3',
    'ر': 'audio/arabic/ra.mp3',
    'ز': 'audio/arabic/zay.mp3',
    'س': 'audio/arabic/seen.mp3',
    'ش': 'audio/arabic/sheen.mp3',
    'ص': 'audio/arabic/saad.mp3',
    'ض': 'audio/arabic/daad.mp3',
    'ط': 'audio/arabic/taa.mp3',
    'ظ': 'audio/arabic/zaa.mp3',
    'ع': 'audio/arabic/ayn.mp3',
    'غ': 'audio/arabic/ghayn.mp3',
    'ف': 'audio/arabic/fa.mp3',
    'ق': 'audio/arabic/qaf.mp3',
    'ك': 'audio/arabic/kaf.mp3',
    'ل': 'audio/arabic/lam.mp3',
    'م': 'audio/arabic/meem.mp3',
    'ن': 'audio/arabic/noon.mp3',
    'ه': 'audio/arabic/ha.mp3',
    'و': 'audio/arabic/waw.mp3',
    'ي': 'audio/arabic/ya.mp3',
  };

  static const Map<String, String> _surahPaths = {
    'surah_fatiha': 'audio/surah/fatiha.mp3',
    'surah_ikhlas': 'audio/surah/ikhlas.mp3',
    'surah_falaq': 'audio/surah/falaq.mp3',
    'surah_nas': 'audio/surah/nas.mp3',
  };

  static const Map<String, String> _legacyAliases = {
    'audio/bangla/aw.mp3': 'audio/bn_vowel_o.wav',
    'audio/bangla/aa.mp3': 'audio/bn_vowel_aa.wav',
    'audio/bangla/i.mp3': 'audio/bn_vowel_i.wav',
    'audio/bangla/ii.mp3': 'audio/bn_vowel_ii.wav',
    'audio/bangla/u.mp3': 'audio/bn_vowel_u.wav',
    'audio/bangla/uu.mp3': 'audio/bn_vowel_uu.wav',
    'audio/bangla/ri.mp3': 'audio/bn_vowel_ri.wav',
    'audio/bangla/e.mp3': 'audio/bn_vowel_e.wav',
    'audio/bangla/oi.mp3': 'audio/bn_vowel_oi.wav',
    'audio/bangla/o.mp3': 'audio/bn_vowel_oo.wav',
    'audio/bangla/ou.mp3': 'audio/bn_vowel_ou.wav',
    'audio/surah/fatiha.mp3': 'audio/surah_fatiha.mp3',
    'audio/surah/ikhlas.mp3': 'audio/surah_ikhlas.mp3',
    'audio/surah/falaq.mp3': 'audio/surah_falaq.mp3',
    'audio/surah/nas.mp3': 'audio/surah_nas.mp3',
  };

  static String? forLearningItem(LearningItem item) {
    if (item.id.startsWith('en_')) {
      return 'audio/english/${item.title.toLowerCase()}.mp3';
    }

    if (item.id.startsWith('bn_vowel_')) {
      return _banglaVowelPaths[item.title];
    }

    if (item.id.startsWith('bn_con_')) {
      return _banglaConsonantPaths[item.title];
    }

    if (item.id.startsWith('ar_')) {
      return _arabicLetterPaths[item.title];
    }

    if (item.id.startsWith('num_')) {
      final number = int.tryParse(item.title);
      if (number != null) {
        return numberAsset(number);
      }
    }

    if (item.audioAsset != null && item.audioAsset!.isNotEmpty) {
      return item.audioAsset;
    }

    return null;
  }

  static String? forSurah(Surah surah) {
    return _surahPaths[surah.id] ?? surah.audioAsset;
  }

  static String numberAsset(int number) {
    return 'audio/numbers/$number.mp3';
  }

  static Iterable<String> legacyCandidates(String logicalPath) sync* {
    final legacy = _legacyAliases[logicalPath];
    if (legacy != null) {
      yield legacy;
    }
  }
}
