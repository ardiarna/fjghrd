import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/oncall_customer_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/opsi.dart';
import 'package:fjghrd/models/customer.dart';

class OncallCustomerTambahForm extends StatelessWidget {
  const OncallCustomerTambahForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OncallCustomerControl>();
    return Container(
      width: Get.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Stack(
        children: [
          ListView(
            children: [
              Visibility(
                visible: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Periode'),
                      ),
                      Expanded(
                        child: GetBuilder<OncallCustomerControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.bulan.label,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihBulan(value: controller.bulan.value);
                                if(a != null && a.value != controller.bulan.value) {
                                  controller.bulan = a;
                                  controller.update();
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: GetBuilder<OncallCustomerControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.tahun.label,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihTahun(value: controller.tahun.value);
                                if(a != null && a.value != controller.tahun.value) {
                                  controller.tahun = a;
                                  controller.update();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Tanggal'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtTanggal,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(AFconvert.matDMYtoYMD(controller.txtTanggal.text)),
                            );
                            if(a != null) {
                              controller.txtTanggal.text = AFconvert.matDate(a);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                child: Row(
                  children: [
                    Container(
                      width: 150,
                      padding: const EdgeInsets.only(right: 15),
                      child: const Text('Customer'),
                    ),
                    Expanded(
                      child: GetBuilder<OncallCustomerControl>(
                        builder: (_) {
                          return AFwidget.comboField(
                            value: controller.customer.nama,
                            label: '',
                            onTap: () async {
                              var a = await controller.pilihCustomer(value: controller.customer.id);
                              if(a != null && a.value != controller.customer.id) {
                                controller.customer = Customer.fromMap(a.data!);
                                controller.update();
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              AFwidget.barisText(
                label: 'Jumlah',
                controller: controller.txtJumlah,
                isNumber: true,
              ),
              AFwidget.barisText(
                label: 'Keterangan',
                controller: controller.txtKeterangan,
                isTextArea: true,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
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
                      onPressed: controller.tambahData,
                      minimumSize: const Size(120, 40),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AFwidget.formHeader('Form Tambah Oncall Customer - ${controller.bulan.label} ${controller.tahun.label}'),
        ],
      ),
    );
  }
}

void showOncallCustomerTambahForm(BuildContext context) {
  final controller = Get.find<OncallCustomerControl>();
  controller.txtId.text = '';
  controller.tahun = Opsi(value: controller.filterTahun.value, label: controller.filterTahun.label);
  controller.bulan = Opsi(value: controller.filterBulan.value, label: controller.filterBulan.label);
  controller.txtTanggal.text = AFconvert.matDate(DateTime(AFconvert.keInt(controller.filterTahun.value), AFconvert.keInt(controller.filterBulan.value)));
  controller.txtKeterangan.text = '';
  controller.txtJumlah.text = '';
  controller.customer = Customer();
  
  AFwidget.dialog(
    const OncallCustomerTambahForm(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
