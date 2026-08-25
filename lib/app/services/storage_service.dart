import 'package:get_storage/get_storage.dart';
import 'package:mrwah/app/modules/login/domain/entities/user.dart';

class StorageService {
  static final _box = GetStorage();

  static const _tokenKey = 'token';
  static const _userKey = 'user';
  static const _firstLaunchKey = 'isFirstLaunch';
  static const _langCodeKey = 'lang_code';
  static const _favoritesKey = 'favorites';
  static const _rememberMeKey = 'remember_me';
  static const _savedEmailKey = 'saved_email';
  static const _savedPasswordKey = 'saved_password';
  static const _biometricEnabledKey = 'biometric_enabled';

  static List<dynamic> getFavorites() =>
      _box.read<List<dynamic>>(_favoritesKey) ?? [];

  static Future<void> saveFavorites(List<dynamic> favorites) async {
    await _box.write(_favoritesKey, favorites);
  }

  static Future<void> clearFavorites() async {
    await _box.remove(_favoritesKey);
  }

  static bool isFavorite(String carId) {
    final favorites = getFavorites();
    return favorites.contains(carId);
  }

  static Future<void> toggleFavorite(String carId) async {
    final favorites = getFavorites();
    if (favorites.contains(carId)) {
      favorites.remove(carId);
    } else {
      favorites.add(carId);
    }
    await saveFavorites(favorites);
  }

  //---- face id ----
  static Future<void> setBiometricEnabled(bool enabled) async {
    await _box.write(_biometricEnabledKey, enabled);
  }

  static bool get isBiometricEnabled =>
      _box.read(_biometricEnabledKey) ?? false;

  // --- Remember Me ---
  static Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _box.write(_rememberMeKey, true);
    await _box.write(_savedEmailKey, email);
    await _box.write(_savedPasswordKey, password);
  }

  static Future<void> clearCredentials() async {
    await _box.remove(_rememberMeKey);
    await _box.remove(_savedEmailKey);
    await _box.remove(_savedPasswordKey);
  }

  static bool get isRememberMe => _box.read(_rememberMeKey) ?? false;
  static String get savedEmail => _box.read(_savedEmailKey) ?? '';
  static String get savedPassword => _box.read(_savedPasswordKey) ?? '';

  // --- Language Storage ---
  static String get langCode => _box.read(_langCodeKey) ?? 'en';
  static set langCode(String code) => _box.write(_langCodeKey, code);
  static bool get isArabic => langCode == 'ar';

  // --- First Launch ---
  static bool get isFirstLaunch => _box.read(_firstLaunchKey) ?? true;
  static set isFirstLaunch(bool value) => _box.write(_firstLaunchKey, value);

  // --- User Storage ---
  static Future<void> saveUser(User user) async {
    await _box.write(_userKey, user.toJson());
    await _box.write(_tokenKey, user.token);
  }

  static String? get token => _box.read<String>(_tokenKey);

  static Map<String, dynamic>? get user =>
      _box.read<Map<String, dynamic>>(_userKey);

  static bool get isLoggedIn => token != null && token!.isNotEmpty;

  static Future<void> updateToken(String newToken) async {
    await _box.write(_tokenKey, newToken);
  }

  static Future<void> clear() async {
    final firstLaunch = isFirstLaunch;
    final lang = langCode;
    final favorites = getFavorites();
    final biometricEnabled = isBiometricEnabled;

    final rememberMe = isRememberMe;
    final email = savedEmail;
    final password = savedPassword;

    await _box.erase();

    // ✅ restore persistent device preferences
    await _box.write(_firstLaunchKey, firstLaunch);
    await _box.write(_langCodeKey, lang);
    await _box.write(_favoritesKey, favorites);
    await _box.write(_biometricEnabledKey, biometricEnabled);

    // ✅ optionally restore remember-me
    if (rememberMe) {
      await saveCredentials(email: email, password: password);
    }
  }
}
