import 'package:fjghrd/controllers/cuti_masal_control.dart';
import 'package:fjghrd/controllers/cuti_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/views/cuti_masal_tambah_karyawan_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/models/cuti.dart';
import 'package:fjghrd/views/cuti_form_view.dart';

class CutiMasalEditView extends StatelessWidget {
  final String id;
  const CutiMasalEditView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CutiMasalControl>(
      init: CutiMasalControl(editId: id),
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: [
              AFwidget.pageHeader(
                title: 'EDIT CUTI MASAL',
                icon: Icons.groups,
                onBack: () {
                    if (Get.isRegistered<CutiControl>()) {
                        Get.find<CutiControl>().loadCutis();
                    }
                    Get.back();
                },
              ),
              if (controller.isLoadingEdit)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else
                ...[
                  _buildTopSection(context, controller),
                  Expanded(
                    child: _buildTableSection(context, controller),
                  ),
                  _buildBottomAction(controller),
                ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopSection(BuildContext context, CutiMasalControl controller) {
    if (controller.dataMasal == null) return const SizedBox();
    var masal = controller.dataMasal!;
    
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                AFwidget.barisText(
                  label: 'Tahun Cuti',
                  controller: TextEditingController(text: masal['tahun']?.toString()),
                  readOnly: true,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15, top: 15),
                        child: const Text('Keterangan'),
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AFwidget.textField(
                                marginTop: 0,
                                readOnly: true,
                                controller: controller.txtKeperluan,
                                maxLines: 4,
                                minLines: 2,
                                keyboard: TextInputType.multiline,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_square, color: Colors.blue),
                              onPressed: () {
                                TextEditingController txt = TextEditingController(text: controller.txtKeperluan.text);
                                _showEditModal('Edit Keterangan Masal', txt, () {
                                  controller.updateKeteranganMasal(txt.text);
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Tgl Kembali',
                  controller: TextEditingController(text: masal['tanggal_kembali'] != null ? AFconvert.matDate(DateTime.parse(masal['tanggal_kembali'])) : ''),
                  readOnly: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AFwidget.barisText(
                  label: 'Lama Hari',
                  controller: TextEditingController(text: masal['lama_hari']?.toString()),
                  readOnly: true,
                ),
                AFwidget.barisText(
                  label: 'Tanggal Cuti',
                  controller: TextEditingController(text: controller.tanggalCutiStrGlobal),
                  readOnly: true,
                  isTextArea: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection(BuildContext context, CutiMasalControl controller) {
    if (controller.dataMasal == null) return const SizedBox();
    
    var filteredList = controller.listCutiEdit.where((c) {
      String nama = c['karyawan']['nama'].toString().toLowerCase();
      return nama.contains(controller.txtCari.text.toLowerCase());
    }).toList();

    return Column(
      children: [
        // HEADER
        Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
          child: Row(
            children: [
              SizedBox(
                width: 80, 
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.add_box, color: Colors.blue),
                    onPressed: () {
                      controller.initTambahKaryawan();
                      AFwidget.dialog(
                        CutiMasalTambahKaryawanView(
                          masalId: controller.editId!,
                          dataMasal: controller.dataMasal!,
                        ),
                        backgroundColor: Colors.transparent,
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Text('Karyawan', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 30,
                        child: TextField(
                          controller: controller.txtCari,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            hintText: 'Cari karyawan...',
                            border: const OutlineInputBorder(),
                            suffixIconConstraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                            suffixIcon: controller.txtCari.text.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      controller.txtCari.clear();
                                    },
                                    child: const Icon(Icons.close, size: 16),
                                  )
                                : const SizedBox(width: 30, height: 30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                )
              ),
              const SizedBox(width: 100, child: Text('Lama', style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(width: 250, child: Text('Tanggal Cuti', style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(width: 200, child: Text('Keterangan', style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(width: 100, child: Text('Tgl Kembali', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
        // BODY
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: filteredList.map((cuti) {
                var karyawan = cuti['karyawan'];
                
                Cuti objCuti = Cuti.fromMap(cuti as Map<String, dynamic>);
                String ket = _getKeterangan(objCuti);
                String lamaHari = _getLamaCuti(objCuti.details);
                String tglCutiStr = objCuti.tanggalCutiStr.isNotEmpty ? objCuti.tanggalCutiStr : _getTanggalCuti(objCuti.details);
                String tglKembali = AFconvert.matDate(objCuti.tanggalKembali);

                return Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Aksi
                      SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                String id = objCuti.id;
                                String jenisForm = objCuti.jenisForm;
                                if (Get.isRegistered<CutiControl>()) {
                                  Get.find<CutiControl>().editForm(id, cutiObj: objCuti);
                                }
                                _openForm(jenisForm);
                              },
                              icon: const Icon(Icons.edit_square),
                              iconSize: 18,
                              color: Colors.green,
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      // Karyawan
                      Expanded(
                        child: Text(
                          karyawan['nama'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      // Lama
                      SizedBox(
                        width: 100,
                        child: Text(lamaHari, style: const TextStyle(fontSize: 13)),
                      ),
                      // Tgl Cuti
                      SizedBox(
                        width: 250,
                        child: Text(tglCutiStr, style: const TextStyle(fontSize: 13)),
                      ),
                      // Keterangan
                      SizedBox(
                        width: 200,
                        child: Text(ket, style: const TextStyle(fontSize: 13)),
                      ),
                      // Tgl Kembali
                      SizedBox(
                        width: 100,
                        child: Text(tglKembali, style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

    String _getKeterangan(Cuti cuti) {
    var listKet = cuti.details.map((e) => e.keterangan.trim()).where((e) => e.isNotEmpty).toList();
    return listKet.toSet().join(', ');
  }

  String _getLamaCuti(List<CutiDetail> details) {
    int hari = 0;
    int bulan = 0;
    
    for (var det in details) {
      String satuan = 'hari';
      if (det.jenisKhusus != null && det.jenisKhusus!['satuan'] != null) {
        satuan = det.jenisKhusus!['satuan'].toString().toLowerCase();
      }
      
      int lama = det.lamaHari;
      if (satuan == 'bulan') {
        bulan += lama;
      } else {
        hari += lama;
      }
    }
    
    List<String> parts = [];
    if (hari > 0 && bulan > 0) {
      parts.add("$hari");
      parts.add("$bulan Bulan");
    } else if (bulan > 0) {
      parts.add("$bulan Bulan");
    } else if (hari > 0) {
      parts.add("$hari");
    } else {
      parts.add("0");
    }
    
    return parts.join(', ');
  }

  String _formatDateShort(DateTime dt) {
    const months = ['', 'Jan', 'Peb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nop', 'Des'];
    return "${dt.day} ${months[dt.month]}";
  }

  String _getTanggalCuti(List<CutiDetail> details) {
    List<String> resultLines = [];
    
    for (var det in details) {
      if (det.dates.isEmpty) continue;
      
      List<DateTime> parsedDates = [];
      for (var d in det.dates) {
        DateTime? dt = d.tanggal;
        if (dt != null) parsedDates.add(dt);
      }
      if (parsedDates.isEmpty) continue;
      
      parsedDates.sort((a, b) => a.compareTo(b));
      
      if (parsedDates.length == 1) {
        resultLines.add(_formatDateShort(parsedDates.first));
      } else if (parsedDates.length > 5) {
        resultLines.add("${_formatDateShort(parsedDates.first)} s/d ${_formatDateShort(parsedDates.last)}");
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
        
        resultLines.add(monthStrings.join(', '));
      }
    }
    
    return resultLines.join(' | ');
  }

  void _openForm(String formType) {
    AFwidget.dialog(
      Container(
        width: 800,
        height: 600,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CutiFormView(formType: formType),
        ),
      ),
      barrierDismissible: false,
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  Widget _buildBottomAction(CutiMasalControl controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              AFwidget.formHapus(
                label: 'Cuti Masal ini',
                aksi: () {
                  Get.back();
                  controller.hapusCutiMasal();
                },
              );
            },
            icon: const Icon(Icons.delete, color: Colors.white),
            label: const Text('Hapus Cuti Masal', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (Get.isRegistered<CutiControl>()) {
                  Get.find<CutiControl>().loadCutis();
              }
              Get.back();
            },
            icon: const Icon(Icons.close, color: Colors.black87),
            label: const Text('Tutup', style: TextStyle(color: Colors.black87)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditModal(String title, TextEditingController txt, VoidCallback onSave) {
    AFwidget.dialog(
      Container(
        width: 400,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AFwidget.formHeader(title),
            Padding(
              padding: const EdgeInsets.all(20),
              child: AFwidget.textField(
                controller: txt,
                label: 'Keterangan',
                maxLines: 4,
                minLines: 2,
                keyboard: TextInputType.multiline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                    onPressed: () {
                      Get.back();
                      onSave();
                    },
                    minimumSize: const Size(120, 40),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
    );
  }
}
