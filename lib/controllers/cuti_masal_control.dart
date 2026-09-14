import 'package:fjghrd/controllers/cuti_control.dart';
import 'package:fjghrd/views/jatah_cuti_tahunan_form.dart';

import 'package:fjghrd/models/karyawan_cuti_masal.dart';
import 'package:fjghrd/repositories/cuti_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_database.dart';

class CutiMasalControl extends GetxController {
  String? editId;
  CutiMasalControl({this.editId});

  final CutiRepository repo = CutiRepository();
  
  late Opsi filterTahun;
  List<Opsi> listTahun = [];
  
  TextEditingController txtKeperluan = TextEditingController();
  TextEditingController txtTglKembali = TextEditingController();
  TextEditingController txtLamaHariGlobal = TextEditingController();
  TextEditingController txtCari = TextEditingController();
  
  List<DateTime> listTanggalGlobal = [];
  List<KaryawanCutiMasal> listKaryawan = [];
  bool checkSemua = true;
  bool isGenerated = false;

  @override
  void onInit() {
    super.onInit();
    txtKeperluan = TextEditingController();
    txtTglKembali = TextEditingController();
    txtLamaHariGlobal = TextEditingController();
    txtKeperluan.addListener(update);
    txtTglKembali.addListener(update);
    txtLamaHariGlobal.addListener(update);
    txtCari.addListener(update);
    
    int startTahun = 2024;
    for (int i = 0; i < 10; i++) {
      listTahun.add(Opsi(value: (startTahun + i).toString(), label: (startTahun + i).toString()));
    }
    
    // Get year from CutiControl if exists
    if(Get.isRegistered<CutiControl>()) {
      filterTahun = Opsi(value: Get.find<CutiControl>().filterTahun.value, label: Get.find<CutiControl>().filterTahun.label);
    } else {
      filterTahun = Opsi(value: DateTime.now().year.toString(), label: DateTime.now().year.toString());
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (editId != null) {
        loadDataEdit();
      } else {
        loadInfoMasal();
      }
    });
  }

  @override
  void onClose() {
    txtKeperluan.dispose();
    txtTglKembali.dispose();
    txtLamaHariGlobal.dispose();
    for(var k in listKaryawan) {
      k.txtLamaHari.dispose();
    }
    super.onClose();
  }

  Future<void> loadInfoMasal() async {
    AFwidget.loading();
    try {
      var hasil = await AFdatabase.send(
        url: 'cuti/info-masal?tahun=${filterTahun.value}',
      );
      Get.back();
      if(hasil.success) {
        listKaryawan.clear();
        for(var a in hasil.daftar) {
          listKaryawan.add(KaryawanCutiMasal.fromMap(a));
        }
        update();
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch(e) {
      Get.back();
      AFwidget.formWarning(label: '$e');
    }
  }

  Future<void> loadSingleInfoMasal(String karyawanId) async {
    try {
      var hasil = await AFdatabase.send(
        url: 'cuti/info-masal?tahun=${filterTahun.value}&karyawan_id=$karyawanId',
      );
      if(hasil.success && hasil.daftar.isNotEmpty) {
        var updatedKaryawan = KaryawanCutiMasal.fromMap(hasil.daftar.first);
        int index = listKaryawan.indexWhere((k) => k.karyawanId == karyawanId);
        if (index != -1) {
          // preserve existing user inputs
          updatedKaryawan.txtLamaHari.text = listKaryawan[index].txtLamaHari.text;
          updatedKaryawan.inputDates = List.from(listKaryawan[index].inputDates);
          updatedKaryawan.isChecked = listKaryawan[index].isChecked;
          updatedKaryawan.pindahKeMinus = listKaryawan[index].pindahKeMinus;
          listKaryawan[index] = updatedKaryawan;
          update();
        }
      }
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<DateTime?> pilihTanggalKaryawan(KaryawanCutiMasal k) async {
    List<Opsi> available = [];
    for (var tgl in listTanggalGlobal) {
      if (!k.inputDates.any((e) => e.year == tgl.year && e.month == tgl.month && e.day == tgl.day)) {
        available.add(Opsi(value: tgl.toIso8601String(), label: DateFormat('dd-MM-yyyy').format(tgl)));
      }
    }
    if (available.isEmpty) {
      AFwidget.snackbar('Semua tanggal cuti utama sudah dipilih');
      return null;
    }
    var res = await AFcombobox.bottomSheet(
      listOpsi: available,
      valueSelected: '',
      judul: 'Pilih Tanggal',
    );
    if (res != null) {
      return DateTime.parse(res.value);
    }
    return null;
  }

  Future<Opsi?> pilihTahun({String value = ''}) async {
    return await AFcombobox.bottomSheet(
      listOpsi: listTahun,
      valueSelected: value,
      judul: 'Pilih Tahun',
    );
  }

  void ubahTahun(Opsi opt) {
    filterTahun = opt;
    update();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (editId != null) {
        loadDataEdit();
      } else {
        loadInfoMasal();
      }
    });
  }

  String get tanggalCutiStrGlobal {
    String str = "";
    if (listTanggalGlobal.isNotEmpty) {
        List<DateTime> parsedDates = List.from(listTanggalGlobal);
        parsedDates.sort((a, b) => a.compareTo(b));
        if (parsedDates.length == 1) {
            str = DateFormat('dd MMM').format(parsedDates.first);
        } else if (parsedDates.length > 5) {
            str = "${DateFormat('dd MMM').format(parsedDates.first)} s/d ${DateFormat('dd MMM').format(parsedDates.last)}";
        } else {
            Map<int, List<int>> grouped = {};
            for (var dt in parsedDates) {
                if (!grouped.containsKey(dt.month)) {
                    grouped[dt.month] = [];
                }
                grouped[dt.month]!.add(dt.day);
            }
            
            List<String> monthStrings = [];
            const months = ['', 'Jan', 'Peb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nop', 'Des'];
            grouped.forEach((m, days) {
                monthStrings.add("${days.join(', ')} ${months[m]}");
            });
            str = monthStrings.join(', ');
        }
    }
    return str;
  }

  void toggleCheckSemua(bool? val) {
    checkSemua = val ?? false;
    for(var k in listKaryawan) {
      k.isChecked = checkSemua;
    }
    update();
  }

  void checkKaryawan(KaryawanCutiMasal k, bool? val) {
    k.isChecked = val ?? false;
    checkSemua = listKaryawan.every((element) => element.isChecked);
    update();
  }

  String get debugCanGenerateReason {
    if (txtKeperluan.text.isEmpty) return 'Keterangan cuti harus diisi';
    if (txtTglKembali.text.isEmpty) return 'Tanggal masuk kembali harus dipilih';
    int lama = AFconvert.keInt(txtLamaHariGlobal.text);
    if (lama <= 0) return 'Lama hari harus diisi (minimal 1)';
    if (listTanggalGlobal.length != lama) return 'Jumlah tanggal cuti harus sama dengan lama hari';
    return '';
  }

  bool get canGenerate => debugCanGenerateReason.isEmpty;

  void executeGenerate() {
    int lama = AFconvert.keInt(txtLamaHariGlobal.text);
    for(var k in listKaryawan) {
      k.txtLamaHari.text = lama.toString();
      k.inputDates = List.from(listTanggalGlobal);
    }
    isGenerated = true;
    update();
  }

  void generateGlobal() {
    if (!canGenerate) return;
    
    if (isGenerated) {
      AFwidget.dialog(
        Container(
          width: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning, color: Colors.orange, size: 50),
              const SizedBox(height: 15),
              const Text('Warning', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Konfigurasi lama hari, tanggal cuti, dan alokasi per karyawan yang sudah Anda ubah akan hilang digenerate ulang. Lanjutkan?', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(onPressed: () => Get.back(), child: const Text('Batal')),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      executeGenerate();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Ya, Regenerate', style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      );
    } else {
      executeGenerate();
    }
  }


  bool get canSubmit => debugCanSubmitReason.isEmpty;

  String get debugCanSubmitReason {
    if (txtKeperluan.text.isEmpty) return 'Keterangan cuti belum diisi';
    if (txtTglKembali.text.isEmpty) return 'Tanggal kembali belum ditentukan';
    
    int globalLama = AFconvert.keInt(txtLamaHariGlobal.text);
    if (globalLama <= 0) return 'Lama hari utama tidak valid (minimal 1 hari)';
    if (listTanggalGlobal.length != globalLama) return 'Jumlah tanggal pada kalender utama tidak sesuai dengan lama hari';
    
    var checkedList = listKaryawan.where((e) => e.isChecked).toList();
    if (checkedList.isEmpty) return 'Silakan pilih setidaknya satu karyawan';
    
    for (var k in checkedList) {
      if (k.inputLamaHari <= 0) return 'Lama hari untuk ${k.nama} tidak valid (minimal 1 hari)';
      if (k.inputLamaHari > globalLama) return 'Lama hari untuk ${k.nama} tidak boleh melebihi lama hari utama';
      if (k.inputDates.length != k.inputLamaHari) return 'Jumlah tanggal cuti untuk ${k.nama} tidak sesuai dengan lama harinya';
    }
    
    return '';
  }

  Future<void> simpanData() async {
    var checkedList = listKaryawan.where((e) => e.isChecked).toList();
    if(checkedList.isEmpty) {
      AFwidget.snackbar('Belum ada karyawan yang diceklist');
      return;
    }
    if(txtKeperluan.text.isEmpty) {
      AFwidget.snackbar('Keterangan cuti harus diisi');
      return;
    }
    
    // validate
    for(var k in checkedList) {
      if(k.inputLamaHari <= 0) {
        AFwidget.formWarning(label: 'Karyawan ${k.nama} memiliki Lama Hari = 0');
        return;
      }
    }
    // List<String> globalDatesStr = listTanggalGlobal.map((e) => AFconvert.matYMD(e)).toList();
    
    // format string tanggal_cuti for backend
    String tanggalCutiStr = "";
    if (listTanggalGlobal.isNotEmpty) {
        List<DateTime> parsedDates = List.from(listTanggalGlobal);
        parsedDates.sort((a, b) => a.compareTo(b));
        if (parsedDates.length == 1) {
            tanggalCutiStr = DateFormat('dd MMM').format(parsedDates.first);
        } else if (parsedDates.length > 5) {
            tanggalCutiStr = "${DateFormat('dd MMM').format(parsedDates.first)} s/d ${DateFormat('dd MMM').format(parsedDates.last)}";
        } else {
            Map<int, List<int>> grouped = {};
            for (var dt in parsedDates) {
                if (!grouped.containsKey(dt.month)) grouped[dt.month] = [];
                grouped[dt.month]!.add(dt.day);
            }
            List<String> monthStrings = [];
            const months = ['', 'Jan', 'Peb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nop', 'Des'];
            grouped.forEach((m, days) {
                monthStrings.add("${days.join(', ')} ${months[m]}");
            });
            tanggalCutiStr = monthStrings.join(', ');
        }
    }

    var body = {
      'tahun': filterTahun.value,
      'keterangan': txtKeperluan.text,
      'tanggal_kembali': txtTglKembali.text != '' ? AFconvert.matYMD(DateFormat('dd-MM-yyyy').parse(txtTglKembali.text)) : null,
      'lama_hari': AFconvert.keInt(txtLamaHariGlobal.text),
      'tanggal_cuti': tanggalCutiStr,
      'global_dates': listTanggalGlobal.map((e) => AFconvert.matYMD(e)).toList(),
      'karyawans': [],
    };


    List<Map<String, dynamic>> kList = [];
    for(var k in checkedList) {
      List<Map<String, dynamic>> details = [];
      
      // We will just do a simple split based on inputLamaHari and inputDates.
      // E.g. if inputLamaHari = 3, splitCutiMasal = 2, splitUnpaid = 1
      // We assign the first 2 dates to CUTI_MASAL, and the rest to UNPAID. If dates are less than lamaHari, they are assigned sequentially.
      int cm = k.splitCutiMasal;
      int unp = k.splitUnpaid;
      
      List<String> strDates = k.inputDates.map((e) => AFconvert.matYMD(e)).toList();
      
      List<String> datesMasal = [];
      List<String> datesUnpaid = [];
      for(int i = 0; i < strDates.length; i++) {
        if(i < cm) {
          datesMasal.add(strDates[i]);
        } else {
          datesUnpaid.add(strDates[i]);
        }
      }

      if(cm > 0) {
        details.add({
          'kategori': 'CUTI_MASAL',
          'lama_hari': cm,
          'dates': datesMasal,
        });
      }
      if(unp > 0) {
        details.add({
          'kategori': 'UNPAID',
          'jenis_unpaid': k.hasJatah ? 'SUDAH_HABIS' : 'SEBELUM_TIMBUL',
          'lama_hari': unp,
          'dates': datesUnpaid,
        });
      }
      
      kList.add({
        'karyawan_id': k.karyawanId,
        'details': details,
      });
    }
    
    body['karyawans'] = kList;

    AFwidget.loading();
    try {
      var hasil = await AFdatabase.send(
        url: 'cuti/submit-masal',
        methodeRequest: MethodeRequest.post,
        body: body,
        contentIsJson: true,
      );
      Get.back();
      if(hasil.success) {
        Get.back(); // Close the page
        AFwidget.snackbar(hasil.message);
        if(Get.isRegistered<CutiControl>()) {
          Get.find<CutiControl>().loadCutis();
        }
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch(e) {
      Get.back();
      AFwidget.formWarning(label: '$e');
    }
  }

  void inputJatahKaryawan(KaryawanCutiMasal k) {
    if(Get.isRegistered<CutiControl>()) {
      // To prefill the Karyawan, we can temporarily set it or just let them pick
      // Wait, we need to pass Karyawan to it. 
      // It's easier to just call inputJatahForm('') and let user pick.
      showJatahCutiTahunanForm('', defaultKaryawanId: k.karyawanId, defaultKaryawanNama: k.nama, defaultTahun: filterTahun.value);
    }
  }

  // --- MERGED FROM EDIT CONTROL ---
  Map<String, dynamic>? dataMasal;
  List<dynamic> listCutiEdit = [];
  bool isLoadingEdit = true;

  Future<void> loadDataEdit() async {
    isLoadingEdit = true;
    update();
    var hasil = await AFdatabase.send(url: 'cuti/masal/$editId');
    if (hasil.success) {
      dataMasal = hasil.data;
      listCutiEdit = dataMasal?['cutis'] ?? [];
      txtKeperluan.text = dataMasal?['keterangan'] ?? '';
      
      listTanggalGlobal.clear();
      if (dataMasal?['dates'] != null) {
          for (var d in dataMasal!['dates']) {
              if (d['tanggal'] != null) {
                  listTanggalGlobal.add(DateTime.parse(d['tanggal']));
              }
          }
      }
    } else {
      AFwidget.snackbar(hasil.message);
    }
    isLoadingEdit = false;
    update();
  }

  Future<void> updateKeteranganMasal(String newKeterangan) async {
    AFwidget.loading();
    var hasil = await AFdatabase.send(
      url: 'cuti/masal/$editId/keterangan',
      methodeRequest: MethodeRequest.put,
      body: {'keterangan': newKeterangan},
    );
    Get.back();
    if (hasil.success) {
      AFwidget.snackbar('Berhasil diupdate');
      loadDataEdit();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> updateKeteranganDetail(String detailId, String newKeterangan) async {
    AFwidget.loading();
    var hasil = await AFdatabase.send(
      url: 'cuti/detail/$detailId/keterangan',
      methodeRequest: MethodeRequest.put,
      body: {'keterangan': newKeterangan},
    );
    Get.back();
    if (hasil.success) {
      AFwidget.snackbar('Berhasil diupdate');
      loadDataEdit();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> hapusCutiKaryawan(String cutiId) async {
    AFwidget.loading();
    var hasil = await AFdatabase.send(
      url: 'cuti/$cutiId',
      methodeRequest: MethodeRequest.delete,
    );
    Get.back();
    if (hasil.success) {
      AFwidget.snackbar('Berhasil dihapus');
      loadDataEdit();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> hapusCutiMasal() async {
    AFwidget.loading();
    var hasil = await AFdatabase.send(
      url: 'cuti/masal/$editId',
      methodeRequest: MethodeRequest.delete,
    );
    Get.back();
    if (hasil.success) {
      Get.back(); // close page
      AFwidget.snackbar('Berhasil dihapus');
      if (Get.isRegistered<CutiControl>()) {
          Get.find<CutiControl>().loadCutis();
      }
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  // --- MERGED FROM TAMBAH KARYAWAN CONTROL ---
  KaryawanCutiMasal? kcmTambah;
  TextEditingController txtKeteranganTambah = TextEditingController();
  bool loadingJatah = false;

  void initTambahKaryawan() {
    kcmTambah = null;
    txtKeteranganTambah.text = dataMasal?['keterangan'] ?? '';
    loadingJatah = false;
  }

  Future<void> fetchJatahKaryawan(String karyawanId, String nama) async {
    loadingJatah = true;
    if (kcmTambah == null) {
      kcmTambah = KaryawanCutiMasal(
        karyawanId: karyawanId,
        nama: nama,
        jabatan: '',
        hasJatah: false,
        totalHakCuti: 0,
        sudahDiambil: 0,
        cutiMasalLama: 0,
        belumDiambil: 0,
        bolehMinus: false,
      );
    } else {
      kcmTambah!.nama = nama;
      kcmTambah!.karyawanId = karyawanId;
    }
    update();
    try {
      var tahun = dataMasal?['tahun'];
      var hasil = await AFdatabase.send(url: 'cuti/info-masal?tahun=$tahun&karyawan_id=$karyawanId');
      if (hasil.success) {
        if (hasil.daftar.isNotEmpty) {
          var dt = hasil.daftar.first as Map<String, dynamic>;
          kcmTambah = KaryawanCutiMasal.fromMap(dt);
          kcmTambah!.nama = nama;
        } else {
          kcmTambah = KaryawanCutiMasal(
            karyawanId: karyawanId,
            nama: nama,
            jabatan: '',
            hasJatah: false,
            totalHakCuti: 0,
            sudahDiambil: 0,
            cutiMasalLama: 0,
            belumDiambil: 0,
            bolehMinus: false,
          );
        }
        kcmTambah!.txtLamaHari.text = dataMasal?['lama_hari']?.toString() ?? '1';
        kcmTambah!.txtLamaHari.addListener(() {
          update();
        });
      } else {
        AFwidget.snackbar(hasil.message);
      }
    } catch (e) {
      AFwidget.snackbar('Error parsing data: $e');
    } finally {
      loadingJatah = false;
      update();
    }
  }

  String get debugCanSaveReasonTambah {
    if (kcmTambah == null) return 'Pilih Karyawan terlebih dahulu.';
    if (kcmTambah!.txtLamaHari.text.isEmpty || AFconvert.keInt(kcmTambah!.txtLamaHari.text) <= 0) return 'Lama Hari harus > 0.';
    if (AFconvert.keInt(kcmTambah!.txtLamaHari.text) > AFconvert.keInt(dataMasal?['lama_hari'])) return 'Lama Hari tidak boleh lebih dari ${dataMasal?['lama_hari']}.';
    if (kcmTambah!.inputDates.length != AFconvert.keInt(kcmTambah!.txtLamaHari.text)) return 'Jumlah Tanggal Cuti yang dipilih (${kcmTambah!.inputDates.length}) tidak sesuai dengan Lama Hari (${kcmTambah!.txtLamaHari.text}).';
    return '';
  }

  bool get canSaveTambah => debugCanSaveReasonTambah == '';

  Future<void> submitTambahKaryawan() async {
    if (!canSaveTambah) {
      AFwidget.formWarning(label: debugCanSaveReasonTambah);
      return;
    }

    AFwidget.loading();

    List<Map<String, dynamic>> details = [];
    
    if (kcmTambah!.splitCutiMasal > 0) {
      details.add({
        'kategori': 'CUTI_MASAL',
        'lama_hari': kcmTambah!.splitCutiMasal,
        'keterangan': txtKeteranganTambah.text,
        'dates': <String>[]
      });
    }

    if (kcmTambah!.splitUnpaid > 0) {
      details.add({
        'kategori': 'UNPAID',
        'lama_hari': kcmTambah!.splitUnpaid,
        'jenis_unpaid': kcmTambah!.hasJatah ? 'SUDAH_HABIS' : 'SEBELUM_TIMBUL',
        'keterangan': txtKeteranganTambah.text,
        'dates': <String>[]
      });
    }

    int assigned = 0;
    List<DateTime> sorted = List.from(kcmTambah!.inputDates);
    sorted.sort();

    for (var d in details) {
      int lama = d['lama_hari'];
      for (int i = 0; i < lama; i++) {
        d['dates'].add(DateFormat('yyyy-MM-dd').format(sorted[assigned]));
        assigned++;
      }
    }

    var body = {
      'karyawans': [
        {
          'karyawan_id': kcmTambah!.karyawanId,
          'details': details
        }
      ]
    };

    var hasil = await AFdatabase.send(
      url: 'cuti/masal/$editId/karyawan',
      methodeRequest: MethodeRequest.post,
      body: body,
      contentIsJson: true,
    );

    Get.back(); // close loading

    if (hasil.success) {
      Get.back(); // close modal
      AFwidget.snackbar('Berhasil menambah karyawan');
      loadDataEdit();
    } else {
      AFwidget.formWarning(label: hasil.message);
    }
  }
}
