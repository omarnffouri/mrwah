import 'package:get_storage/get_storage.dart';

/// Persists payment links keyed by their deposit/transaction id
/// so pending bookings can still launch payment even if the API
/// response does not include the URL.
class PaymentLinkStorage {
  static const _key = 'payment_links';
  static final _box = GetStorage();

  static Future<void> saveFromUrl(String url) async {
    final depositId = _extractDepositId(url);
    if (depositId == null) return;

    final stored = _readMap();
    stored[depositId] = url;
    await _box.write(_key, stored);
  }

  static String? getForId(String? id) {
    if (id == null || id.isEmpty) return null;
    return _readMap()[id];
  }

  /// Extracts the segment after `/rent/` and before `/u/`
  /// Example: https://mrwah.org/gateways/deposits/rent/49/u/2/m -> 49
  static String? _extractDepositId(String url) {
    final match =
        RegExp(r'rent/([^/]+)/u/', caseSensitive: false).firstMatch(url);
    return match?.group(1);
  }

  static Map<String, String> _readMap() {
    final raw = _box.read<Map>(_key) ?? {};
    return raw.map((key, value) => MapEntry("$key", "$value"));
  }
}
