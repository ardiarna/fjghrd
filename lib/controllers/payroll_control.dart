import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/potongan.dart';
import 'package:fjghrd/models/hari_libur.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/medical.dart';
import 'package:fjghrd/models/overtime.dart';
import 'package:fjghrd/models/payroll.dart';
import 'package:fjghrd/models/penghasilan.dart';
import 'package:fjghrd/repositories/hari_libur_repository.dart';
import 'package:fjghrd/repositories/medical_repository.dart';
import 'package:fjghrd/repositories/overtime_repository.dart';
import 'package:fjghrd/repositories/payroll_repository.dart';
import 'package:fjghrd/repositories/penghasilan_repository.dart';
import 'package:fjghrd/repositories/potongan_repository.dart';
import 'package:fjghrd/repositories/upah_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/payroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayrollControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final PayrollRepository _payrollRepo = PayrollRepository();
  final UpahRepository _upahRepo = UpahRepository();

  final DateTime _now = DateTime.now();

  List<Payroll> listPayroll = [];
  List<Payroll> listDetilPayroll = [];
  List<Karyawan> listKaryawan = [];
  Map<String, int> totalKaryawanPerArea = {};
  List<Overtime> listOvertime = [];
  List<Medical> listMedical = [];
  List<Penghasilan> listPenghasilan = [];
  List<Potongan> listPotongan = [];
  List<HariLibur> listHariLibur = [];
  List<Opsi> listBulan = mapBulan.entries.map((e) => Opsi(value: e.key.toString(), label: e.value)).toList();
  late List<Opsi> listTahun;
  Payroll currentPayroll = Payroll();
  Payroll currentDetilPayroll = Payroll();

  late TextEditingController txtTanggalAwal, txtTanggalAkhir,
      txtGaji, txtKenaikanGaji, txtHariMakan, txtUangMakanHarian, txtUangMakanJumlah, txtOvertimeFjg, txtOvertimeCus,
      txtMedical, txtThr, txtBonus, txtInsentif, txtTelkomsel, txtLain, txtPot25hari, txtPot25jumlah,
      txtPotTelepon, txtPotBensin, txtPotKas, txtPotCicilan, txtPotBpjs, txtPotCutiHari, txtPotCutiJumlah, txtPotLain,
      txtPotKompensasiJam, txtPotKompensasiJumlah, txtTotalDiterima, txtKeterangan;
  late Opsi filterTahun;
  late Opsi tahun;
  late Opsi bulan;

  Future<void> loadPayrolls() async {
    var hasil = await _payrollRepo.findAll(tahun: filterTahun.value);
    if (hasil.success) {
      listPayroll.clear();
      for (var data in hasil.daftar) {
        listPayroll.add(Payroll.fromMap(data));
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<bool> payrollPeriodeIsExist(String tahun, String bulan) async {
    var hasil = await _payrollRepo.findAll(tahun: tahun, bulan: bulan);
    if(hasil.success) {
      if(hasil.daftar.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  Future<void> loadDetilPayrolls() async {
    var hasil = await _payrollRepo.findDetail(currentPayroll.id);
    if (hasil.success) {
      listDetilPayroll.clear();
      for (var data in hasil.daftar) {
        listDetilPayroll.add(Payroll.fromMap(data));
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> loadKaryawans() async {
    var hasil = await _upahRepo.findAll();
    if (hasil.success) {
      listKaryawan.clear();
      totalKaryawanPerArea.clear();
      for (var data in hasil.daftar) {
        var k = Karyawan.fromMap(data);
        listKaryawan.add(k);
        if(k.staf) {
          if (totalKaryawanPerArea.containsKey(k.area.nama)) {
            totalKaryawanPerArea[k.area.nama] = totalKaryawanPerArea[k.area.nama]! + 1;
          } else {
            totalKaryawanPerArea[k.area.nama] = 1;
          }
        }
      }
      for (var k in listKaryawan) {
        if(k.staf == false) {
          if (totalKaryawanPerArea.containsKey('NON STAF')) {
            totalKaryawanPerArea['NON STAF'] = totalKaryawanPerArea['NON STAF']! + 1;
          } else {
            totalKaryawanPerArea['NON STAF'] = 1;
          }
        }
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> loadOvertimes() async {
    final OvertimeRepository repo = OvertimeRepository();
    var hasil = await repo.findAll(
      tahun: tahun.value,
      bulan: bulan.value,
    );
    if (hasil.success) {
      listOvertime.clear();
      for (var data in hasil.daftar) {
        listOvertime.add(Overtime.fromMap(data));
      }
    }
  }

  Future<void> loadMedicals() async {
    final MedicalRepository repo = MedicalRepository();
    var hasil = await repo.findAll(
      tahun: tahun.value,
      bulan: bulan.value,
      jenis: 'R',
    );
    if (hasil.success) {
      listMedical.clear();
      for (var data in hasil.daftar) {
        listMedical.add(Medical.fromMap(data));
      }
    }
  }

  Future<void> loadPenghasilans() async {
    final PenghasilanRepository repo = PenghasilanRepository();
    var hasil = await repo.findAll(
      tahun: tahun.value,
      bulan: bulan.value,
    );
    if (hasil.success) {
      listPenghasilan.clear();
      for (var data in hasil.daftar) {
        listPenghasilan.add(Penghasilan.fromMap(data));
      }
    }
  }

  Future<void> loadPotongans() async {
    final PotonganRepository repo = PotonganRepository();
    var hasil = await repo.findAll(
      tahun: tahun.value,
      bulan: bulan.value,
    );
    if (hasil.success) {
      listPotongan.clear();
      for (var data in hasil.daftar) {
        listPotongan.add(Potongan.fromMap(data));
      }
    }
  }

  Future<void> loadHariLiburs() async {
    final HariLiburRepository repo = HariLiburRepository();
    var hasil = await repo.findAll(tahun: tahun.value);
    if (hasil.success) {
      listHariLibur.clear();
      for (var data in hasil.daftar) {
        listHariLibur.add(HariLibur.fromMap(data));
      }
    }
  }

  int countWorkingDays() {
    DateTime startDate = AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggalAwal.text)} 00:00:00') ?? _now;
    DateTime endDate = AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggalAkhir.text)} 00:00:00') ?? _now;
    int workingDays = 0;
    for (DateTime date = startDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday &&
          !listHariLibur.any((liburan) => liburan.tanggal != null && liburan.tanggal!.year == date.year && liburan.tanggal!.month == date.month && liburan.tanggal!.day == date.day)) {
        workingDays++;
      }
    }
    return workingDays;
  }

  void hitungPenerimaanBersih (String nilai) {
    var a = AFconvert.keInt(txtGaji.text) + AFconvert.keInt(txtKenaikanGaji.text) + AFconvert.keInt(txtUangMakanJumlah.text) +
        AFconvert.keInt(txtOvertimeFjg.text) + AFconvert.keInt(txtOvertimeCus.text) +
        AFconvert.keInt(txtMedical.text) + AFconvert.keInt(txtThr.text) +
        AFconvert.keInt(txtBonus.text) + AFconvert.keInt(txtInsentif.text) +
        AFconvert.keInt(txtTelkomsel.text) + AFconvert.keInt(txtLain.text);
    var b = AFconvert.keInt(txtPot25jumlah.text) + AFconvert.keInt(txtPotTelepon.text) +
        AFconvert.keInt(txtPotBensin.text) + AFconvert.keInt(txtPotKas.text) +
        AFconvert.keInt(txtPotCicilan.text) + AFconvert.keInt(txtPotBpjs.text) +
        AFconvert.keInt(txtPotCutiJumlah.text) + AFconvert.keInt(txtPotKompensasiJumlah.text) + AFconvert.keInt(txtPotLain.text);
    var c = a - b;
    txtTotalDiterima.text = AFconvert.matNumber(c);
  }

  Future<bool> runPayroll({
    required String tglAwal,
    required String tglAkhir,
    required String tahun,
    required String bulan,
    required List<Map<String, dynamic>> payrolls,
    String keterangan = '',
  }) async {
    try {
      AFwidget.loading();
      var hasil = await _payrollRepo.create(
        tglAwal: tglAwal,
        tglAkhir: tglAkhir,
        tahun: tahun,
        bulan: bulan,
        payrolls: payrolls,
        keterangan: keterangan,
      );
      Get.back();
      AFwidget.snackbar(hasil.message);
      return hasil.success;
    } catch (er) {
      AFwidget.snackbar('$er');
      return false;
    }
  }

  void kunciPayrollForm({
    required String id,
    required String periode,
  }) {
    AFwidget.formKonfirmasi(
      label: 'Apakah anda ingin mengunci payroll periode $periode ?',
      ikon: Icons.lock_outline,
      aksi: () {
        _kunciPayroll(id);
      },
    );
  }

  Future<void> _kunciPayroll(String id) async {
    try {
      AFwidget.loading();
      var hasil = await _payrollRepo.kunci(id);
      Get.back();
      if(hasil.success) {
        loadPayrolls();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');

    }
  }

  void ubahForm(BuildContext context) {
    txtTanggalAwal.text = AFconvert.matDate(currentPayroll.tanggalAwal);
    txtTanggalAkhir.text = AFconvert.matDate(currentPayroll.tanggalAkhir);
    tahun = Opsi(value: '${currentPayroll.tahun}', label: '${currentPayroll.tahun}');
    bulan = Opsi(value: '${currentPayroll.bulan}', label: mapBulan[currentPayroll.bulan]!);
    txtKeterangan.text = currentPayroll.keterangan;
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 60, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 240,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Periode Penggajian'),
                      ),
                      Expanded(
                        child: GetBuilder<PayrollControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: bulan.label,
                              label: '',
                              onTap: () async {
                                var a = await pilihBulan(value: bulan.value);
                                if(a != null && a.value != bulan.value) {
                                  bulan = a;
                                  update();
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: GetBuilder<PayrollControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: tahun.label,
                              label: '',
                              onTap: () async {
                                var a = await pilihTahun(value: tahun.value);
                                if(a != null && a.value != tahun.value) {
                                  tahun = a;
                                  update();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 240,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Periode Batas (Cut-off)'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: txtTanggalAwal,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(AFconvert.matDMYtoYMD(txtTanggalAwal.text)),
                            );
                            if(a != null) {
                              txtTanggalAwal.text = AFconvert.matDate(a);
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                        child: Text('s/d', textAlign: TextAlign.center),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: txtTanggalAkhir,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(AFconvert.matDMYtoYMD(txtTanggalAkhir.text)),
                            );
                            if(a != null) {
                              txtTanggalAkhir.text = AFconvert.matDate(a);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                barisText(
                  label: 'Keterangan',
                  controller: txtKeterangan,
                  isTextArea: true,
                  lebarLabel: 240,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AFwidget.tombol(
                        label: 'Hapus',
                        color: Colors.red,
                        onPressed: hapusForm,
                        minimumSize: const Size(120, 40),
                      ),
                      const Spacer(),
                      AFwidget.tombol(
                        label: 'Batal',
                        color: Colors.orange,
                        onPressed: Get.back,
                        minimumSize: const Size(120, 40),
                      ),
                      const SizedBox(width: 40),
                      AFwidget.tombol(
                        label: 'Simpan',
                        color: Colors.blue,
                        onPressed: ubahData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 55,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Text('Form Ubah Payroll',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void hapusForm() {
    AFwidget.formHapus(
      label: 'payroll ${mapBulan[currentPayroll.bulan]} ${currentPayroll.tahun}',
      aksi: () {
        hapusData(currentPayroll.id);
      },
    );
  }

  void ubahDetilForm(String id, BuildContext context) {
    currentDetilPayroll = listDetilPayroll.where((element) => element.id == id).first;
    txtGaji.text = AFconvert.matNumber(currentDetilPayroll.gaji);
    txtKenaikanGaji.text = AFconvert.matNumber(currentDetilPayroll.kenaikanGaji);
    txtHariMakan.text = AFconvert.matNumber(currentDetilPayroll.hariMakan);
    txtUangMakanHarian.text = AFconvert.matNumber(currentDetilPayroll.uangMakanHarian);
    txtUangMakanJumlah.text = AFconvert.matNumber(currentDetilPayroll.uangMakanJumlah);
    txtOvertimeFjg.text = AFconvert.matNumber(currentDetilPayroll.overtimeFjg);
    txtOvertimeCus.text = AFconvert.matNumber(currentDetilPayroll.overtimeCus);
    txtMedical.text = AFconvert.matNumber(currentDetilPayroll.medical);
    txtThr.text = AFconvert.matNumber(currentDetilPayroll.thr);
    txtBonus.text = AFconvert.matNumber(currentDetilPayroll.bonus);
    txtInsentif.text = AFconvert.matNumber(currentDetilPayroll.insentif);
    txtTelkomsel.text = AFconvert.matNumber(currentDetilPayroll.telkomsel);
    txtLain.text = AFconvert.matNumber(currentDetilPayroll.lain);
    txtPot25hari.text = AFconvert.matNumber(currentDetilPayroll.pot25hari);
    txtPot25jumlah.text = AFconvert.matNumber(currentDetilPayroll.pot25jumlah);
    txtPotTelepon.text = AFconvert.matNumber(currentDetilPayroll.potTelepon);
    txtPotBensin.text = AFconvert.matNumber(currentDetilPayroll.potBensin);
    txtPotKas.text = AFconvert.matNumber(currentDetilPayroll.potKas);
    txtPotCicilan.text = AFconvert.matNumber(currentDetilPayroll.potCicilan);
    txtPotBpjs.text = AFconvert.matNumber(currentDetilPayroll.potBpjs);
    txtPotCutiHari.text = AFconvert.matNumber(currentDetilPayroll.potCutiHari);
    txtPotCutiJumlah.text = AFconvert.matNumber(currentDetilPayroll.potCutiJumlah);
    txtPotKompensasiJam.text = AFconvert.matNumberWithDecimal(currentDetilPayroll.potKompensasiJam, decimal: 1);
    txtPotKompensasiJumlah.text = AFconvert.matNumber(currentDetilPayroll.potKompensasiJumlah);
    txtPotLain.text = AFconvert.matNumber(currentDetilPayroll.potLain);
    txtTotalDiterima.text = AFconvert.matNumber(currentDetilPayroll.totalDiterima);
    txtKeterangan.text = currentDetilPayroll.keterangan;
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: [
            ListView(
              children: [
                barisInfo(
                  label: 'Nama Karyawan',
                  nilai: currentDetilPayroll.karyawan.nama,
                  paddingTop: 60,
                ),
                barisInfo(
                  label: 'Jabatan',
                  nilai: currentDetilPayroll.karyawan.jabatan.nama,
                ),
                barisInfo(
                  label: 'Masa Kerja',
                  nilai: AFconvert.matDate(currentDetilPayroll.karyawan.tanggalMasuk),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    'A. PENGHASILAN',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
                barisText(
                  label: 'Gaji Pokok',
                  controller: txtGaji,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'Kenaikan Gaji',
                  controller: txtKenaikanGaji,
                  onchanged: hitungPenerimaanBersih,
                ),
                currentDetilPayroll.makanHarian ?
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 21, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 230,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('U/makan & Transport'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hari :'),
                            AFwidget.textField(
                              marginTop: 0,
                              controller: txtHariMakan,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = AFconvert.keInt(nilai) * AFconvert.keInt(txtUangMakanHarian.text);
                                txtUangMakanJumlah.text = AFconvert.matNumber(jumlah);
                                hitungPenerimaanBersih(nilai);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('@Hari IDR :'),
                            AFwidget.textField(
                              marginTop: 0,
                              controller: txtUangMakanHarian,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = AFconvert.keInt(nilai) * AFconvert.keInt(txtHariMakan.text);
                                txtUangMakanJumlah.text = AFconvert.matNumber(jumlah);
                                hitungPenerimaanBersih(nilai);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Jumlah IDR :'),
                            AFwidget.textField(
                              readOnly: true,
                              marginTop: 0,
                              controller: txtUangMakanJumlah,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) :
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 21, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 230,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('U/makan & Transport'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hari :'),
                            AFwidget.textField(
                              marginTop: 0,
                              controller: txtHariMakan,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Jumlah IDR :'),
                            AFwidget.textField(
                              marginTop: 0,
                              controller: txtUangMakanJumlah,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                barisText(
                  label: 'Overtime Fratekindo',
                  controller: txtOvertimeFjg,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'Overtime Customer',
                  controller: txtOvertimeCus,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'Reimbursement Medical',
                  controller: txtMedical,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'Tunjangan Hari Raya',
                  controller: txtThr,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'Bonus',
                  controller: txtBonus,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'Insentif',
                  controller: txtInsentif,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'Telkomsel',
                  controller: txtTelkomsel,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'Lain-Lain',
                  controller: txtLain,
                  onchanged: hitungPenerimaanBersih,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    'B. POTONGAN',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
                currentDetilPayroll.makanHarian ?
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 21, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 230,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Keterlambatan Kehadiran 25%'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hari :'),
                            AFwidget.textField(
                              marginTop: 0,
                              controller: txtPot25hari,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = (AFconvert.keInt(txtUangMakanHarian.text)/4) * AFconvert.keInt(nilai) ;
                                txtPot25jumlah.text = AFconvert.matNumber(jumlah);
                                hitungPenerimaanBersih(nilai);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Jumlah IDR :'),
                            AFwidget.textField(
                              readOnly: true,
                              marginTop: 0,
                              controller: txtPot25jumlah,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) :
                Container(),
                barisText(
                  label: 'Pemakaian Telepon',
                  controller: txtPotTelepon,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'Pemakaian Bensin',
                  controller: txtPotBensin,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'Pinjaman Kas',
                  controller: txtPotKas,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'Pinjaman Cicilan',
                  controller: txtPotCicilan,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'BPJS Kesehatan',
                  controller: txtPotBpjs,
                  onchanged: hitungPenerimaanBersih,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 21, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 230,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Unpaid Leave'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hari :'),
                            AFwidget.textField(
                              marginTop: 0,
                              controller: txtPotCutiHari,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = ((AFconvert.keInt(txtGaji.text)+AFconvert.keInt(txtKenaikanGaji.text))/21) * AFconvert.keInt(nilai) ;
                                txtPotCutiJumlah.text = AFconvert.matNumber(jumlah);
                                hitungPenerimaanBersih(nilai);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Jumlah IDR :'),
                            AFwidget.textField(
                              readOnly: true,
                              marginTop: 0,
                              controller: txtPotCutiJumlah,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 21, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 230,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Kompensasi Hadir (Jam)'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Jam :'),
                            AFwidget.textField(
                              marginTop: 0,
                              controller: txtPotKompensasiJam,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 1,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = ((AFconvert.keInt(txtGaji.text)+AFconvert.keInt(txtKenaikanGaji.text))/168) * AFconvert.keDouble(nilai) ;
                                txtPotKompensasiJumlah.text = AFconvert.matNumber(jumlah);
                                hitungPenerimaanBersih(nilai);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Jumlah IDR :'),
                            AFwidget.textField(
                              readOnly: true,
                              marginTop: 0,
                              controller: txtPotKompensasiJumlah,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                barisText(
                  label: 'Lain Lain',
                  controller: txtPotLain,
                  onchanged: hitungPenerimaanBersih,
                ),
                barisText(
                  label: 'Peneriman Bersih (A-B)',
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                  controller: txtTotalDiterima,
                  readOnly: true,
                  paddingTop: 31,
                ),
                barisText(
                  label: 'Keterangan',
                  controller: txtKeterangan,
                  isTextArea: true,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AFwidget.tombol(
                        label: 'Batal',
                        color: Colors.orange,
                        onPressed: Get.back,
                        minimumSize: const Size(120, 40),
                      ),
                      const SizedBox(width: 40),
                      AFwidget.tombol(
                        label: 'Simpan',
                        color: Colors.blue,
                        onPressed: ubahDetilData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 55,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Text('Form Ubah Payroll Karyawan',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  Future<void> ubahData() async {
    try {
      if(currentPayroll.id.isEmpty) {
        throw 'ID Payroll tidak ditemukan';
      }
      if(tahun.value.isEmpty || bulan.value.isEmpty) {
        throw 'Periode penggajian harus diisi';
      }
      if(txtTanggalAwal.text.isEmpty || txtTanggalAkhir.text.isEmpty) {
        throw 'Periode batas (cut-off) harus diisi';
      }
      AFwidget.loading();
      var id = currentPayroll.id;
      var hasil = await _payrollRepo.update(
        id: id,
        tglAwal: txtTanggalAwal.text,
        tglAkhir: txtTanggalAkhir.text,
        bulan: bulan.value,
        tahun: tahun.value,
        keterangan: txtKeterangan.text,
      );
      Get.back();
      if(hasil.success) {
        Get.back();
        await loadPayrolls();
        currentPayroll = listPayroll.where((element) => element.id == id).first;
        update();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> hapusData(String id) async {
    try {
      if(id == '') {
        throw 'ID Payroll null';
      }
      AFwidget.loading();
      var hasil = await _payrollRepo.delete(id);
      Get.back();
      if(hasil.success) {
        loadPayrolls();
        Get.back();
        Get.back();
        homeControl.kontener = PayrollView();
        homeControl.update();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> ubahDetilData() async {
    try {
      if(currentDetilPayroll.id.isEmpty) {
        throw 'ID Payroll tidak ditemukan';
      }
      if(txtGaji.text.isEmpty) {
        throw 'Gaji harus diisi';
      }
      var a = Payroll(
        id: currentDetilPayroll.id,
        headerId: currentDetilPayroll.headerId,
        makanHarian: currentDetilPayroll.makanHarian,
        gaji: AFconvert.keInt(txtGaji.text),
        kenaikanGaji: AFconvert.keInt(txtKenaikanGaji.text),
        hariMakan: AFconvert.keInt(txtHariMakan.text),
        uangMakanHarian: AFconvert.keInt(txtUangMakanHarian.text),
        uangMakanJumlah: AFconvert.keInt(txtUangMakanJumlah.text),
        overtimeFjg: AFconvert.keInt(txtOvertimeFjg.text),
        overtimeCus: AFconvert.keInt(txtOvertimeCus.text),
        medical: AFconvert.keInt(txtMedical.text),
        thr: AFconvert.keInt(txtThr.text),
        bonus: AFconvert.keInt(txtBonus.text),
        insentif: AFconvert.keInt(txtInsentif.text),
        telkomsel: AFconvert.keInt(txtTelkomsel.text),
        lain: AFconvert.keInt(txtLain.text),
        pot25hari: AFconvert.keInt(txtPot25hari.text),
        pot25jumlah: AFconvert.keInt(txtPot25jumlah.text),
        potTelepon: AFconvert.keInt(txtPotTelepon.text),
        potBensin: AFconvert.keInt(txtPotBensin.text),
        potKas: AFconvert.keInt(txtPotKas.text),
        potCicilan: AFconvert.keInt(txtPotCicilan.text),
        potBpjs: AFconvert.keInt(txtPotBpjs.text),
        potCutiHari: AFconvert.keInt(txtPotCutiHari.text),
        potCutiJumlah: AFconvert.keInt(txtPotCutiJumlah.text),
        potKompensasiJam: AFconvert.keDouble(txtPotKompensasiJam.text),
        potKompensasiJumlah: AFconvert.keInt(txtPotKompensasiJumlah.text),
        potLain: AFconvert.keInt(txtPotLain.text),
        totalDiterima: AFconvert.keInt(txtTotalDiterima.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = currentDetilPayroll.karyawan;
      AFwidget.loading();
      var hasil = await _payrollRepo.updateDetail(a);
      Get.back();
      if(hasil.success) {
        loadDetilPayrolls();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<Opsi?> pilihTahun({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listTahun,
      valueSelected: value,
      judul: 'Pilih Tahun',
      withCari: false,
    );
    return a;
  }

  Future<Opsi?> pilihBulan({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listBulan,
      valueSelected: value,
      judul: 'Pilih Bulan',
      withCari: false,
    );
    return a;
  }

  Widget barisInfo({
    String label = '',
    String nilai = '',
    double paddingTop = 20,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, paddingTop, 20, 0),
      child: Row(
        children: [
          Container(
            width: 230,
            padding: const EdgeInsets.only(right: 15),
            child: Text(label),
          ),
          Expanded(
            child: Text(': $nilai',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget barisText({
    String label = '',
    TextEditingController? controller,
    double paddingTop = 11,
    double lebarLabel = 230,
    bool isTextArea = false,
    Function(String)? onchanged,
    TextStyle? style,
    bool readOnly = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, paddingTop, 20, 0),
      child: Row(
        crossAxisAlignment: isTextArea ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            width: lebarLabel,
            padding: EdgeInsets.only(right: 15, top: isTextArea ? 15 : 0),
            child: Text(label, style: style),
          ),
          Expanded(
            child: AFwidget.textField(
              readOnly: readOnly,
              marginTop: 0,
              controller: controller,
              maxLines: isTextArea ? 4 : 1,
              minLines: isTextArea ? 2 : 1,
              keyboard: isTextArea ? TextInputType.multiline : TextInputType.text,
              inputformatters: isTextArea ? null : [
                CurrencyTextInputFormatter.currency(
                  symbol: '',
                  decimalDigits: 0,
                ),
              ],
              textAlign: isTextArea ? TextAlign.start : TextAlign.end,
              onchanged: onchanged,
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void onInit() {
    filterTahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    tahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    bulan = Opsi(value: '${_now.month}', label: mapBulan[_now.month]!);
    listTahun = List.generate(_now.year-2019, (index) => Opsi(value: '${_now.year-index}', label: '${_now.year-index}'));
    txtTanggalAwal = TextEditingController();
    txtTanggalAkhir = TextEditingController();
    txtGaji = TextEditingController();
    txtKenaikanGaji = TextEditingController();
    txtHariMakan = TextEditingController();
    txtUangMakanHarian = TextEditingController();
    txtUangMakanJumlah = TextEditingController();
    txtOvertimeFjg = TextEditingController();
    txtOvertimeCus = TextEditingController();
    txtMedical = TextEditingController();
    txtThr = TextEditingController();
    txtBonus = TextEditingController();
    txtInsentif = TextEditingController();
    txtTelkomsel = TextEditingController();
    txtLain = TextEditingController();
    txtPot25hari = TextEditingController();
    txtPot25jumlah = TextEditingController();
    txtPotTelepon = TextEditingController();
    txtPotBensin = TextEditingController();
    txtPotKas = TextEditingController();
    txtPotCicilan = TextEditingController();
    txtPotBpjs = TextEditingController();
    txtPotCutiHari = TextEditingController();
    txtPotCutiJumlah = TextEditingController();
    txtPotKompensasiJam = TextEditingController();
    txtPotKompensasiJumlah = TextEditingController();
    txtPotLain = TextEditingController();
    txtTotalDiterima = TextEditingController();
    txtKeterangan = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtTanggalAwal.dispose();
    txtTanggalAkhir.dispose();
    txtGaji.dispose();
    txtKenaikanGaji.dispose();
    txtHariMakan.dispose();
    txtUangMakanHarian.dispose();
    txtUangMakanJumlah.dispose();
    txtOvertimeFjg.dispose();
    txtOvertimeCus.dispose();
    txtMedical.dispose();
    txtThr.dispose();
    txtBonus.dispose();
    txtInsentif.dispose();
    txtTelkomsel.dispose();
    txtLain.dispose();
    txtPot25hari.dispose();
    txtPot25jumlah.dispose();
    txtPotTelepon.dispose();
    txtPotBensin.dispose();
    txtPotKas.dispose();
    txtPotCicilan.dispose();
    txtPotBpjs.dispose();
    txtPotCutiHari.dispose();
    txtPotCutiJumlah.dispose();
    txtPotKompensasiJam.dispose();
    txtPotKompensasiJumlah.dispose();
    txtPotLain.dispose();
    txtTotalDiterima.dispose();
    txtKeterangan.dispose();
    super.onClose();
  }
}
