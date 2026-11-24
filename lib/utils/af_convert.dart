import 'package:fjghrd/utils/af_constant.dart';
import 'package:intl/intl.dart';

abstract class AFconvert {
  static String keString(dynamic nilai) {
    if (nilai is String) {
      return nilai;
    } else if (nilai is List<String>) {
      return nilai.join(',');
    } else if (nilai is bool) {
      return nilai == true ? 'Y' : 'N';
    } else if (nilai != null) {
      return nilai.toString();
    } else {
      return '';
    }
  }

  static int keInt(dynamic nilai) {
    if (nilai is num) {
      return nilai.toInt();
    } else if (nilai != null && nilai != '') {
      String strVal = nilai.toString();
      strVal = strVal.replaceAll(',', '').replaceAll('.', '');
      if(int.tryParse(strVal) != null) {
        return int.parse(strVal);
      }
      if (double.tryParse(strVal) != null) {
        return double.parse(strVal).toInt();
      }
    }
    return 0;
  }

  static double keDouble(dynamic nilai) {
    if (nilai is num) {
      return nilai.toDouble();
    } else if (nilai != null) {
      String strVal = nilai.toString();
      if(double.tryParse(strVal) != null) {
        return double.parse(strVal);
      }
    }
    return 0;
  }

  static bool keBool(dynamic nilai) {
    if (nilai != null) {
      if (nilai is String) {
        if (nilai == 'Y' || nilai == 'true' || nilai == 't'|| nilai == '1') {
          return true;
        } else {
          return false;
        }
      } else {
        return nilai;
      }
    } else {
      return false;
    }
  }

  static DateTime? keTanggal(dynamic nilai) {
    if (nilai is DateTime) {
      return nilai;
    } else if (nilai != null && nilai != '') {
      String str = nilai.toString().trim();
      DateTime? dt = DateTime.tryParse(str);
      if (dt != null) return dt;
      try {
        return DateFormat('dd-MM-yyyy').parse(str);
      } catch (_) {}
      return null;
    } else {
      return null;
    }
  }

  static String matDate(DateTime? nilai) {
    final mat = DateFormat('dd-MM-yyyy');
    return nilai != null ? mat.format(nilai) : '';
  }

  static String matYMD(DateTime? nilai) {
    final mat = DateFormat('yyyy-MM-dd');
    return nilai != null ? mat.format(nilai) : '';
  }

  static String matYMDTime(DateTime? nilai) {
    final mat = DateFormat('yyyy-MM-dd HH:mm');
    return nilai != null ? mat.format(nilai) : '';
  }

  static String matMD(DateTime? nilai) {
    final mat = DateFormat('MM-dd');
    return nilai != null ? mat.format(nilai) : '';
  }

  static String matDMYtoYMD(String nilai) {
    if (nilai.isEmpty) return '';
    List<String> tanggal = nilai.split('-');
    if (tanggal.length != 3) return nilai;
    if (tanggal[0].length == 4) return nilai;
    return '${tanggal[2]}-${tanggal[1]}-${tanggal[0]}';
  }

  static String matMonthYear(DateTime? nilai) {
    final mat = DateFormat('yyyy');
    return nilai != null ? '${mapBulan[nilai.month]} ${mat.format(nilai)}' : '';
  }

  static String matNumber(dynamic nilai) {
    final mat = NumberFormat('#,###');
    return nilai != null ? mat.format(nilai) : '0';
  }

  static String matNumberWithDecimal(dynamic nilai, {int decimal = 2}) {
    final mat = NumberFormat('#,##0.${'0' * decimal}');
    return nilai != null ? mat.format(nilai) : '0';
  }

}