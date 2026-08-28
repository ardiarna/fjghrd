import 'package:fjghrd/controllers/cuti_control.dart';
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
  final CutiRepository repo = CutiRepository();
  
  late Opsi filterTahun;
  List<Opsi> listTahun = [];
  
  TextEditingController txtKeperluan = TextEditingController();
  TextEditingController txtTglKembali = TextEditingController();
  TextEditingController txtLamaHariGlobal = TextEditingController();
  
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
      loadInfoMasal();
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
      loadInfoMasal();
    });
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

    var body = {
      'tahun': filterTahun.value,
      'keterangan': txtKeperluan.text,
      'tanggal_kembali': txtTglKembali.text != '' ? AFconvert.matYMD(DateFormat('dd-MM-yyyy').parse(txtTglKembali.text)) : null,
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
        AFwidget.formWarning(
          label: hasil.message, 
          ikon: Icons.check_circle, 
          warna: Colors.green
        );
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
      var cutiCtrl = Get.find<CutiControl>();
      // To prefill the Karyawan, we can temporarily set it or just let them pick
      // Wait, we need to pass Karyawan to it. 
      // It's easier to just call inputJatahForm('') and let user pick.
      cutiCtrl.inputJatahForm('', defaultKaryawanId: k.karyawanId, defaultKaryawanNama: k.nama, defaultTahun: filterTahun.value);
    }
  }
}
