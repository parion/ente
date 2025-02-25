import 'package:ente_auth/models/code.dart';
import 'package:flutter/foundation.dart';
import 'package:otp/otp.dart' as otp;
import 'package:steam_totp/steam_totp.dart';

String getOTP(Code code) {
  if (code.type == Type.steam) {
    return _getSteamCode(code);
  }
  if (code.type == Type.hotp) {
    return _getHOTPCode(code);
  }
  return otp.OTP.generateTOTPCodeString(
    getSanitizedSecret(code.secret),
    DateTime.now().millisecondsSinceEpoch,
    length: code.digits,
    interval: code.period,
    algorithm: _getAlgorithm(code),
    isGoogle: true,
  );
}

String _getHOTPCode(Code code) {
  return otp.OTP.generateHOTPCodeString(
    getSanitizedSecret(code.secret),
    code.counter,
    length: code.digits,
    algorithm: _getAlgorithm(code),
    isGoogle: true,
  );
}

String _getSteamCode(Code code, [bool isNext = false]) {
  final SteamTOTP steamtotp = SteamTOTP(secret: code.secret);

  return steamtotp.generate(
    DateTime.now().millisecondsSinceEpoch ~/ 1000 + (isNext ? code.period : 0),
  );
}

String getNextTotp(Code code) {
  if (code.type == Type.steam) {
    return _getSteamCode(code, true);
  }
  return otp.OTP.generateTOTPCodeString(
    getSanitizedSecret(code.secret),
    DateTime.now().millisecondsSinceEpoch + code.period * 1000,
    length: code.digits,
    interval: code.period,
    algorithm: _getAlgorithm(code),
    isGoogle: true,
  );
}

otp.Algorithm _getAlgorithm(Code code) {
  switch (code.algorithm) {
    case Algorithm.sha256:
      return otp.Algorithm.SHA256;
    case Algorithm.sha512:
      return otp.Algorithm.SHA512;
    default:
      return otp.Algorithm.SHA1;
  }
}

String getSanitizedSecret(String secret) {
  return secret.toUpperCase().trim().replaceAll(' ', '');
}

String safeDecode(String value) {
  try {
    return Uri.decodeComponent(value);
  } catch (e) {
    // note: don't log the value, it might contain sensitive information
    debugPrint("Failed to decode $e");
    return value;
  }
}
