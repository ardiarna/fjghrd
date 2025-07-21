class DurasiTanggal {

  final int tahun;
  final int bulan;
  final int hari;

  DurasiTanggal({
    required this.tahun,
    required this.bulan,
    required this.hari,
  });

  factory DurasiTanggal.diff(DateTime awal, DateTime akhir) {
    int tahun = akhir.year - awal.year;
    int bulan = akhir.month - awal.month;
    int hari = akhir.day - awal.day;

    if (hari < 0) {
      bulan -= 1;
      // Ambil jumlah hari di bulan sebelumnya
      final prevMonth = DateTime(akhir.year, akhir.month, 0);
      hari += prevMonth.day;
    }

    if (bulan < 0) {
      tahun -= 1;
      bulan += 12;
    }

    return DurasiTanggal(tahun: tahun, bulan: bulan, hari: hari);
  }

  String cetak() {
    List<String> parts = [];
    if (tahun > 0) parts.add('$tahun tahun');
    if (bulan > 0) parts.add('$bulan bulan');
    if (hari > 0) parts.add('$hari hari');
    return parts.isEmpty ? '0 hari' : parts.join(' ');
  }

}