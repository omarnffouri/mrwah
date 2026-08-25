import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    final bool canCheck = await _auth.canCheckBiometrics;
    final bool isDeviceSupported = await _auth.isDeviceSupported();
    return canCheck && isDeviceSupported;
  }

  Future<bool> authenticate() async {
    try {
      final types = await _auth.getAvailableBiometrics();
      if (types.isEmpty) return false;

      return await _auth.authenticate(
        localizedReason: 'Unlock the app',
      );
    } catch (_) {
      return false;
    }
  }
}
