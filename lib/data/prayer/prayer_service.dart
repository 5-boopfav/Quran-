import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PresetCity {
  final String name;
  final double latitude;
  final double longitude;
  final CalculationMethod method;

  const PresetCity({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.method,
  });
}

class PrayerTimesBundle {
  final String cityName;
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final Prayer nextPrayer;
  final DateTime? nextPrayerTime;

  const PrayerTimesBundle({
    required this.cityName,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.nextPrayer,
    required this.nextPrayerTime,
  });
}

class PrayerService {
  static const String _cityNameKey = 'prayer_city_name_v1';
  static const String _latKey = 'prayer_lat_v1';
  static const String _lngKey = 'prayer_lng_v1';
  static const String _methodKey = 'prayer_method_v1';

  static const List<PresetCity> cities = [
    PresetCity(
      name: 'الرياض',
      latitude: 24.7136,
      longitude: 46.6753,
      method: CalculationMethod.umm_al_qura,
    ),
    PresetCity(
      name: 'مكة المكرمة',
      latitude: 21.3891,
      longitude: 39.8579,
      method: CalculationMethod.umm_al_qura,
    ),
    PresetCity(
      name: 'المدينة المنورة',
      latitude: 24.5247,
      longitude: 39.5692,
      method: CalculationMethod.umm_al_qura,
    ),
    PresetCity(
      name: 'جدة',
      latitude: 21.4858,
      longitude: 39.1925,
      method: CalculationMethod.umm_al_qura,
    ),
    PresetCity(
      name: 'القاهرة',
      latitude: 30.0444,
      longitude: 31.2357,
      method: CalculationMethod.egyptian,
    ),
    PresetCity(
      name: 'دبي',
      latitude: 25.2048,
      longitude: 55.2708,
      method: CalculationMethod.dubai,
    ),
  ];

  Future<void> saveCity(PresetCity city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cityNameKey, city.name);
    await prefs.setDouble(_latKey, city.latitude);
    await prefs.setDouble(_lngKey, city.longitude);
    await prefs.setInt(_methodKey, city.method.index);
  }

  Future<bool> requestLocationAndUpdateCity() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cityNameKey, 'موقعي الحالي');
      await prefs.setDouble(_latKey, position.latitude);
      await prefs.setDouble(_lngKey, position.longitude);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<PrayerTimesBundle> getTodayPrayerTimes({DateTime? date}) async {
    final prefs = await SharedPreferences.getInstance();
    final cityName = prefs.getString(_cityNameKey) ?? 'الرياض';
    final lat = prefs.getDouble(_latKey) ?? 24.7136;
    final lng = prefs.getDouble(_lngKey) ?? 46.6753;
    final methodIndex =
        prefs.getInt(_methodKey) ?? CalculationMethod.umm_al_qura.index;

    final method =
        (methodIndex >= 0 && methodIndex < CalculationMethod.values.length)
            ? CalculationMethod.values[methodIndex]
            : CalculationMethod.umm_al_qura;

    final coordinates = Coordinates(lat, lng);
    final params = method.getParameters();
    params.madhab = Madhab.shafi;

    final targetDate = date ?? DateTime.now();
    final dateComponents = DateComponents.from(targetDate);
    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

    final nextPrayer = prayerTimes.nextPrayer();
    final nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer);

    return PrayerTimesBundle(
      cityName: cityName,
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
      nextPrayer: nextPrayer,
      nextPrayerTime: nextPrayerTime,
    );
  }

  static String prayerArabicName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      case Prayer.none:
        return 'الفجر غداً';
    }
  }
}
