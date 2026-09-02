import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/customer.dart';
import 'package:fjghrd/repositories/customer_repository.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class CustomerControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final CustomerRepository _repo = CustomerRepository();

  RxList<Customer> listCustomer = <Customer>[].obs;

  late TextEditingController txtId, txtNama, txtAlamat;

  Future<void> loadCustomers() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listCustomer.assignAll(hasil.daftar.map<Customer>((data) => Customer.fromMap(data)).toList());
      
    }
  }

  

  

  Future<void> simpanData() async {
    try {
      if(txtNama.text.isEmpty) {
        throw ValidationException('Nama harus diisi');
      }

      var a = Customer(
        id: txtId.text,
        nama: txtNama.text,
        alamat: txtAlamat.text,
      );

      AFwidget.loading();
      var hasil = a.id == ''
          ? await _repo.create(a.toMap())
          : await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadCustomers();
        authControl.customerUpdateTrigger.value++;
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
        throw ValidationException('ID Customer null');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadCustomers();
        authControl.customerUpdateTrigger.value++;
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

  @override
  void onInit() {
    txtId = TextEditingController();
    txtNama = TextEditingController();
    txtAlamat = TextEditingController();
    loadCustomers();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtNama.dispose();
    txtAlamat.dispose();
    super.onClose();
  }
}
