import 'package:fjghrd/controllers/cuti_masal_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/controllers/cuti_control.dart';
import 'package:fjghrd/views/jatah_cuti_tahunan_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CutiMasalTambahKaryawanView extends StatelessWidget {
  final String masalId;
  final Map<String, dynamic> dataMasal;

  const CutiMasalTambahKaryawanView({super.key, required this.masalId, required this.dataMasal});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CutiMasalControl>(
      builder: (controller) {
        return Container(
          width: 550,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AFwidget.formHeader('TAMBAH KARYAWAN'),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Pilih Karyawan
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                      child: Row(
                        children: [
                          const SizedBox(width: 150, child: Text('Pilih Karyawan')),
                          Expanded(
                            child: AFwidget.comboField(
                              value: controller.kcmTambah?.nama ?? '',
                              label: '',
                              onTap: () async {
                                if (!Get.isRegistered<CutiControl>()) {
                                  AFwidget.snackbar('Error: CutiControl tidak ditemukan!');
                                  return;
                                }
                                var cc = Get.find<CutiControl>();
                                var a = await cc.pilihKaryawan(value: controller.kcmTambah?.karyawanId ?? '');
                                if (a != null) {
                                  if (a.value != controller.kcmTambah?.karyawanId) {
                                    await controller.fetchJatahKaryawan(a.value, a.label);
                                  }
                                  controller.update();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 2. Input Jatah / Keterangan Hak
                    if (controller.loadingJatah)
                      const Padding(padding: EdgeInsets.only(left: 170, top: 5, bottom: 5), child: Text('Loading kuota...', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))),
                    
                    if (controller.kcmTambah != null && !controller.loadingJatah && controller.kcmTambah!.hasJatah)
                      Padding(
                        padding: const EdgeInsets.only(left: 170, top: 5, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hak: ${controller.kcmTambah!.totalHakCuti}, Sisa: ${controller.kcmTambah!.belumDiambil}', style: const TextStyle(fontSize: 12, color: Colors.blue)),
                            Text('Diambil: ${controller.kcmTambah!.sudahDiambil}, C.Masal: ${controller.kcmTambah!.cutiMasalLama}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      
                    if (controller.kcmTambah != null && !controller.loadingJatah && !controller.kcmTambah!.hasJatah)
                      Padding(
                        padding: const EdgeInsets.only(left: 170, top: 5, bottom: 5),
                        child: Row(
                          children: [
                            const Text('Belum ada jatah cuti.', style: TextStyle(color: Colors.red)),
                            TextButton(
                              onPressed: () {
                                Get.back(); // close modal
                                showJatahCutiTahunanForm(
                                  '',
                                  defaultKaryawanId: controller.kcmTambah!.karyawanId,
                                  defaultKaryawanNama: controller.kcmTambah!.nama,
                                  defaultTahun: dataMasal['tahun'].toString(),
                                );
                              },
                              child: const Text('Input Jatah'),
                            )
                          ],
                        ),
                      ),
                      
                    // 3. Keterangan
                    AFwidget.barisText(
                      label: 'Keterangan',
                      controller: controller.txtKeteranganTambah,
                      isTextArea: true,
                    ),

                    // 4. Tgl Kembali
                    AFwidget.barisText(
                      label: 'Tgl Kembali',
                      controller: TextEditingController(text: dataMasal['tanggal_kembali']),
                      readOnly: true,
                    ),
                    
                    // 5. Lama Hari
                    if (controller.kcmTambah != null)
                      AFwidget.barisText(
                        label: 'Lama Hari',
                        controller: controller.kcmTambah!.txtLamaHari,
                        isNumber: true,
                      ),
                      
                    // 6. Tanggal Cuti
                    if (controller.kcmTambah != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                        child: Row(
                          children: [
                            const SizedBox(width: 150, child: Text('Tanggal Cuti')),
                            Expanded(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  for (var tgl in controller.kcmTambah!.inputDates)
                                    Chip(
                                      label: Text(DateFormat('dd-MM-yyyy').format(tgl)),
                                      onDeleted: () {
                                        controller.kcmTambah!.inputDates.remove(tgl);
                                        controller.update();
                                      },
                                    ),
                                  if (controller.kcmTambah!.inputDates.length < (int.tryParse(controller.kcmTambah!.txtLamaHari.text) ?? 0))
                                    ActionChip(
                                      label: const Text('Tambah'),
                                      avatar: const Icon(Icons.add, size: 16),
                                      onPressed: () async {
                                        var a = await controller.pilihTanggalKaryawan(controller.kcmTambah!);
                                        if (a != null) {
                                          controller.kcmTambah!.inputDates.add(a);
                                          controller.update();
                                        }
                                      },
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                    // 7. Alokasi
                    if (controller.kcmTambah != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 170, top: 5, bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Alokasi:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    const Text('Cuti Masal: ', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                    Text(
                                      '${controller.kcmTambah!.splitCutiMasal}',
                                      style: TextStyle(fontSize: 12, color: controller.kcmTambah!.splitCutiMasal > 0 ? Colors.green : Colors.black, fontWeight: controller.kcmTambah!.splitCutiMasal > 0 ? FontWeight.bold : FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Unpaid: ', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                    Text(
                                      '${controller.kcmTambah!.splitUnpaid}',
                                      style: TextStyle(fontSize: 12, color: controller.kcmTambah!.splitUnpaid > 0 ? Colors.orange : Colors.black, fontWeight: controller.kcmTambah!.splitUnpaid > 0 ? FontWeight.bold : FontWeight.normal),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text('Sisa Akhir: ', style: TextStyle(fontSize: 12, color: controller.kcmTambah!.sisaAkhir == 0 ? Colors.black : (controller.kcmTambah!.sisaAkhir > 0 ? Colors.green : Colors.red))),
                                    Text(
                                      '${controller.kcmTambah!.sisaAkhir}',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: controller.kcmTambah!.sisaAkhir == 0 ? Colors.black : (controller.kcmTambah!.sisaAkhir > 0 ? Colors.green : Colors.red)),
                                    ),
                                  ],
                                ),
                                if (controller.kcmTambah!.bolehMinus && (controller.kcmTambah!.splitUnpaid > 0 || controller.kcmTambah!.pindahKeMinus))
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: Checkbox(
                                            value: controller.kcmTambah!.pindahKeMinus,
                                            onChanged: (val) {
                                              controller.kcmTambah!.pindahKeMinus = val ?? false;
                                              controller.update();
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text('Pindah ke Cuti Masal', style: TextStyle(fontSize: 11, color: Colors.blue)),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                    const SizedBox(height: 15),
                    if (controller.debugCanSaveReasonTambah != '')
                      Padding(
                        padding: const EdgeInsets.only(left: 170),
                        child: Text(controller.debugCanSaveReasonTambah, style: const TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 25),
                child: Row(
                  children: [
                    const Spacer(),
                    AFwidget.tombol(
                      label: 'Batal',
                      color: Colors.orange,
                      onPressed: () => Get.back(),
                      minimumSize: const Size(120, 40),
                    ),
                    const SizedBox(width: 20),
                    AFwidget.tombol(
                      label: 'Simpan',
                      color: Colors.blue,
                      onPressed: controller.canSaveTambah ? controller.submitTambahKaryawan : null,
                      minimumSize: const Size(120, 40),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
