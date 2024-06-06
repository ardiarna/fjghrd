import 'package:flutter/material.dart';

abstract class Rute {
  static const home = '/';
  static const login = '/login';
  static const karyawanForm = '/karyawanform';
  static const karyawanPayrollView = '/karyawan-payroll';
  static const akunForm = '/akunform';
  static const passwordForm = '/passwordform';
}

Map<int, String> mapBulan = {
  1: 'Januari',
  2: 'Februari',
  3: 'Maret',
  4: 'April',
  5: 'Mei',
  6: 'Juni',
  7: 'Juli',
  8: 'Agustus',
  9: 'September',
  10: 'Oktober',
  11: 'November',
  12: 'Desember',
};

Map<int, String> mapHari = {
  1: 'Senin',
  2: 'Selasa',
  3: 'Rabu',
  4: 'Kamis',
  5: 'Jumat',
  6: 'Sabtu',
  7: 'Minggu',
};

Map<String, IconData?> mapIkon = {
  'access_time': Icons.access_time_outlined,
  'account_balance_wallet': Icons.account_balance_wallet_outlined,
  'app_registration': Icons.app_registration_outlined,
  'app_settings_alt': Icons.app_settings_alt_outlined,
  'assignment_late' : Icons.assignment_late_outlined,
  'assignment_turned_in': Icons.assignment_turned_in_outlined,
  'beach_access': Icons.beach_access_outlined,
  'bolt': Icons.bolt_outlined,
  'bookmark': Icons.bookmark_outlined,
  'bookmark_add': Icons.bookmark_add_outlined,
  'bookmark_remove': Icons.bookmark_remove_outlined,
  'calculate': Icons.calculate_outlined,
  'calendar_today': Icons.calendar_today_outlined,
  'card_travel': Icons.card_travel_outlined,
  'category': Icons.category_outlined,
  'cottage': Icons.cottage_outlined,
  'description': Icons.description_outlined,
  'description_outlined': Icons.description_outlined,
  'dining': Icons.dining_outlined,
  'edgesensor_high': Icons.edgesensor_high_outlined,
  'emoji_objects': Icons.emoji_objects_outlined,
  'emoji_nature': Icons.emoji_nature_outlined,
  'escalator_warning': Icons.escalator_warning_outlined,
  'flash_on': Icons.flash_on_outlined,
  'flatware': Icons.flatware_outlined,
  'gite': Icons.gite_outlined,
  'grass': Icons.grass_outlined,
  'history_edu': Icons.history_edu_outlined,
  'house': Icons.house_outlined,
  'how_to_vote': Icons.how_to_vote,
  'invert_colors': Icons.invert_colors_outlined,
  'local_fire_department': Icons.local_fire_department_outlined,
  'medication': Icons.medication_outlined,
  'medical_services': Icons.medical_services_outlined,
  'miscellaneous_services': Icons.miscellaneous_services_outlined,
  'mobile_screen_share': Icons.mobile_screen_share_outlined,
  'moped': Icons.moped_outlined,
  'motorcycle': Icons.motorcycle_outlined,
  'offline_bolt': Icons.offline_bolt_outlined,
  'opacity': Icons.opacity_outlined,
  'pending_actions': Icons.pending_actions_outlined,
  'phone_android': Icons.phone_android_outlined,
  'phone_iphone': Icons.phone_iphone_outlined,
  'quiz': Icons.quiz_outlined,
  'shop': Icons.shop_outlined,
  'shop_2': Icons.shop_2_outlined,
  'shopping_bag': Icons.shopping_bag_outlined,
  'shopping_cart': Icons.shopping_cart_outlined,
  'table_chart': Icons.table_chart_outlined,
  'table_rows': Icons.table_rows_outlined,
};