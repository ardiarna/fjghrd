import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/customer.dart';
import 'package:fjghrd/models/oncall_customer.dart';
import 'package:fjghrd/repositories/customer_repository.dart';
import 'package:fjghrd/repositories/oncall_customer_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class OncallCustomerControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final OncallCustomerRepository _repo = OncallCustomerRepository();

  final DateTime _now = DateTime.now();

  RxList<OncallCustomer> listOncallCustomer = <OncallCustomer>[].obs;
  List<Opsi> listCustomer = [];
  List<Opsi> listBulan = mapBulan.entries.map((e) => Opsi(value: e.key.toString(), label: e.value)).toList();
  late List<Opsi> listTahun;

  late Opsi filterTahun;
  late Opsi filterBulan;

  late TextEditingController txtId, txtTanggal, txtJumlah, txtKeterangan;
  Customer customer = Customer();
  late Opsi tahun;
  late Opsi bulan;

  Future<void> loadOncallCustomers() async {
    var hasil = await _repo.findAll(
      tahun: filterTahun.value,
      bulan: filterBulan.value,
    );
    if (hasil.success) {
      List<OncallCustomer> tempList = [];
      for (var data in hasil.daftar) {
        tempList.add(OncallCustomer.fromMap(data));
      }
      listOncallCustomer.assignAll(tempList);
    }
  }

  Future<void> loadCustomers() async {
    CustomerRepository repo = CustomerRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listCustomer.clear();
      for (var data in hasil.daftar) {
        listCustomer.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
      update();
    }
  }

  Future<void> tambahData() async {
    try {
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw ValidationException('Periode harus diisi');
      }
      if(txtTanggal.text.isEmpty) {
        throw ValidationException('Tanggal harus diisi');
      }
      if(customer.id.isEmpty) {
        throw ValidationException('Silakan pilih customer');
      }
      if(txtJumlah.text.isEmpty) {
        throw ValidationException('Jumlah harus diisi');
      }

      var a = OncallCustomer(
        tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
        bulan: AFconvert.keInt(bulan.value),
        tahun: AFconvert.keInt(tahun.value),
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.customer = customer;

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadOncallCustomers();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> ubahData() async {
    try {
      if(txtId.text.isEmpty) {
        throw ValidationException('ID pvertime & oncall_ customer tidak ditemukan');
      }
      if(customer.id.isEmpty) {
        throw ValidationException('Silakan pilih customer');
      }
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw ValidationException('Periode harus diisi');
      }
      if(txtTanggal.text.isEmpty) {
        throw ValidationException('Tanggal harus diisi');
      }
      if(txtJumlah.text.isEmpty) {
        throw ValidationException('Jumlah harus diisi');
      }
      var a = OncallCustomer(
        tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
        bulan: AFconvert.keInt(bulan.value),
        tahun: AFconvert.keInt(tahun.value),
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.customer = customer;

      AFwidget.loading();
      var hasil = await _repo.update(txtId.text, a.toMap());
      Get.back();
      if(hasil.success) {
        loadOncallCustomers();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusData(String id) async {
    try {
      if(id == '') {
        throw ValidationException('ID overtime & oncall customer tidak ditemukan');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadOncallCustomers();
        Get.back();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusBanyakData() async {
    try {
      AFwidget.loading();
      var hasil = await _repo.deleteAll(
        tahun: filterTahun.value,
        bulan: filterBulan.value,
      );
      Get.back();
      if(hasil.success) {
        loadOncallCustomers();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<Opsi?> pilihCustomer({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listCustomer,
      valueSelected: value,
      judul: 'Pilih Customer',
    );
    return a;
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

  @override
  void onInit() {
    ever(authControl.customerUpdateTrigger, (_) => loadCustomers());
    filterTahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    filterBulan = Opsi(value: '${_now.month}', label: mapBulan[_now.month]!);
    tahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    bulan = Opsi(value: '${_now.month}', label: mapBulan[_now.month]!);
    listTahun = List.generate(_now.year-2019, (index) => Opsi(value: '${_now.year-index}', label: '${_now.year-index}'));
    txtId = TextEditingController();
    txtTanggal = TextEditingController();
    txtJumlah = TextEditingController();
    txtKeterangan = TextEditingController();
    loadOncallCustomers();
    loadCustomers();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtTanggal.dispose();
    txtJumlah.dispose();
    txtKeterangan.dispose();
    super.onClose();
  }
}
