import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/oncall_customer_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/models/opsi.dart';

class OncallCustomerUbahForm extends StatelessWidget {
  const OncallCustomerUbahForm({super.key});

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
                            id: 'form_oncall',
                            builder: (_) {
                              return AFwidget.comboField(
                                value: controller.bulan.label,
                              label: '',
                              onTap: null,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: GetBuilder<OncallCustomerControl>(
                            id: 'form_oncall',
                            builder: (_) {
                              return AFwidget.comboField(
                                value: controller.tahun.label,
                              label: '',
                              onTap: null,
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
                          ontap: null,
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
                            id: 'form_oncall',
                            builder: (_) {
                              return AFwidget.comboField(
                                value: controller.customer.nama,
                            label: '',
                            onTap: null,
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
                onchanged: (_) => controller.update(['form_oncall']),
              ),
              AFwidget.barisText(
                label: 'Keterangan',
                controller: controller.txtKeterangan,
                isTextArea: true,
              ),
              GetBuilder<OncallCustomerControl>(
                id: 'form_oncall',
                builder: (_) {
                  String msg = controller.pesanValidasi;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                    child: Row(
                      children: [
                        AFwidget.tombol(
                          label: 'Hapus',
                          color: Colors.red,
                          onPressed: () {
                            AFwidget.formHapus(
                              label: 'data oncall customer ini',
                              aksi: () {
                                controller.hapusData(controller.txtId.text);
                              },
                            );
                          },
                          minimumSize: const Size(120, 40),
                        ),
                        const SizedBox(width: 20),
                        if(msg.isNotEmpty)
                          Expanded(
                            child: Text(msg, style: const TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
                          )
                        else
                          const Spacer(),
                        AFwidget.tombol(
                          label: 'Batal',
                          color: Colors.orange,
                          onPressed: Get.back,
                          minimumSize: const Size(120, 40),
                        ),
                        const SizedBox(width: 20),
                        AFwidget.tombol(
                          label: 'Simpan',
                          color: msg.isEmpty ? Colors.blue : Colors.grey,
                          onPressed: msg.isEmpty ? controller.ubahData : null,
                          minimumSize: const Size(120, 40),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          AFwidget.formHeader('Form Ubah Oncall Customer'),
        ],
      ),
    );
  }
}

void showOncallCustomerUbahForm(String id, BuildContext context) {
  final controller = Get.find<OncallCustomerControl>();
  var item = controller.listOncallCustomer.where((element) => element.id == id).first;
  controller.txtId.text = item.id;
  controller.tahun = Opsi(value: '${item.tahun}', label: '${item.tahun}');
  controller.bulan = Opsi(value: '${item.bulan}', label: mapBulan[item.bulan]!);
  controller.txtTanggal.text = AFconvert.matDate(item.tanggal);
  controller.txtKeterangan.text = item.keterangan;
  controller.txtJumlah.text = AFconvert.matNumber(item.jumlah);
  controller.customer = item.customer;
  
  AFwidget.dialog(
    const OncallCustomerUbahForm(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
