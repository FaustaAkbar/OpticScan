part of 'app_pages.dart';

// ROUTE UNTUK NAVIGASI
abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const TES = _Paths.TES;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const SPLASHSCREEN = _Paths.SPLASHSCREEN;
  static const PROFILE = _Paths.PROFILE;
  static const RIWAYAT = _Paths.RIWAYAT;
  static const EYESCANNER = _Paths.EYESCANNER;
  static const EYESCANRESULT = _Paths.EYESCANRESULT;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const TES = '/tes';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const SPLASHSCREEN = '/splashscreen';
  static const PROFILE = '/profile';
  static const RIWAYAT = '/riwayat';
  static const EYESCANNER = '/eyescanner';
  static const EYESCANRESULT = '/eyescanresult';
}
