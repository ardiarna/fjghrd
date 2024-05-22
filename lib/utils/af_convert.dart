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
    if (nilai is int) {
      return nilai;
    } else if (nilai != null && nilai != '') {
      if(nilai is String) {
        nilai = nilai.replaceAll(',', '');
        nilai = nilai.replaceAll('.', '');
      }
      if(int.tryParse(nilai) != null) {
        return int.parse(nilai);
      }
    }
    return 0;
  }

  static double keDouble(dynamic nilai) {
    if (nilai is double) {
      return nilai;
    } else if (nilai != null) {
      if(double.tryParse(nilai) != null) {
        return double.parse(nilai);
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
      return DateTime.parse(nilai);
    } else {
      return null;
    }
  }

  static List<String> keList(dynamic nilai) {
    if (nilai != null) {
      if (nilai is String) {
        return nilai.split(',');
      } else {
        return nilai.toString().split(',');
      }
    } else {
      return [];
    }
  }

  static String matDateTime(DateTime? nilai) {
    final mat = DateFormat('dd-MM-yyyy HH:mm');
    return nilai != null ? mat.format(nilai) : '';
  }

  static String matDate(DateTime? nilai) {
    final mat = DateFormat('dd-MM-yyyy');
    return nilai != null ? mat.format(nilai) : '';
  }

  static String matTime(DateTime? nilai) {
    final mat = DateFormat('HH:mm');
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

  static String matDMYtoYMD(String nilai) {
    List<String> tanggal = nilai.split('-');
    return '${tanggal[2]}-${tanggal[1]}-${tanggal[0]}';
  }

  static String matYMDtoDate(String nilai) {
    List<String> tanggal = nilai.split('-');
    return '${tanggal[2]} ${mapBulan[int.parse(tanggal[1])]} ${tanggal[0]}';
  }

  static String matNumber(dynamic nilai) {
    final mat = NumberFormat('#,###');
    return nilai != null ? mat.format(nilai) : '0';
  }

}