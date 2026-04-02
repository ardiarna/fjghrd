import 'package:fjghrd/models/opsi.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

export 'package:fjghrd/models/opsi.dart';

class DaftarOpsi extends StatefulWidget {
  final List<Opsi> listOpsi;
  final String valueSelected;
  final bool withCari;
  final String judul;

  const DaftarOpsi({
    required this.listOpsi,
    this.valueSelected = "",
    this.withCari = true,
    required this.judul,
    super.key,
  });

  @override
  State<DaftarOpsi> createState() => _DaftarOpsiState();
}

class _DaftarOpsiState extends State<DaftarOpsi> {
  List<Opsi> _listFilter = [];
  late TextEditingController txtCari;

  @override
  void initState() {
    super.initState();
    _listFilter = widget.listOpsi;
    txtCari = TextEditingController();
  }

  @override
  void dispose() {
    txtCari.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double tinggiAtas = widget.withCari ? (widget.judul != "" ? 80 : 60) : (widget.judul != "" ? 30 : 10);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: (tinggiAtas+10)),
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: _listFilter.length,
            itemBuilder: (_, i) {
              return RadioGroup<String>(
                groupValue: widget.valueSelected,
                onChanged: (val) {
                  Get.back<Opsi>(result: _listFilter[i]);
                },
                child: GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                    decoration: BoxDecoration(
                      color: _listFilter[i].value == widget.valueSelected ? Get.theme.primaryColor.withValues(alpha: 0.25) : Colors.white,
                    ),
                    child: Row(
                      children: [
                        _listFilter[i].icon != null ?
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 13, 10),
                          child: Icon(_listFilter[i].icon),
                        ) :
                        Radio(value: _listFilter[i].value),
                        Expanded(
                          child: Text(_listFilter[i].label, overflow: TextOverflow.ellipsis),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 15)),
                        Text(_listFilter[i].label2)
                      ],
                    ),
                  ),
                  onTap: () {
                    Get.back<Opsi>(result: _listFilter[i]);
                  },
                ),
              );
            },
            separatorBuilder: (_, i) {
              return const Divider(
                indent: 45,
                endIndent: 20,
                height: 5,
                thickness: 1,
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: tinggiAtas,
          child: Column(
            children: [
              widget.judul != "" ?
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(widget.judul,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
              ) : Container(),
              widget.withCari ?
              TextField(
                controller: txtCari,
                decoration: InputDecoration(
                  labelText: "Cari...",
                  suffix: GestureDetector(
                    child: const Icon(Icons.close, color: Colors.grey,),
                    onTap: () {
                      txtCari.text = "";
                      setState(() {
                        _listFilter = widget.listOpsi;
                      });
                    },
                  ),
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(10),
                ),
                onChanged: (value) {
                  List<Opsi> listCari = [];
                  for (var opsi in widget.listOpsi) {
                    bool cek =
                    opsi.label.toLowerCase().contains(value.toLowerCase());
                    if (cek) {
                      listCari.add(opsi);
                    }
                  }
                  setState(() {
                    _listFilter = listCari;
                  });
                },
              ) : Container(),
            ],
          ),
        ),
      ],
    );
  }
}

abstract class AFcombobox {

  static Future<String?> ikon({String valueSelected = "", Color? color, double? size}) {
    return Get.bottomSheet<String>(
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 15, bottom: 5, top: 40),
              alignment: Alignment.center,
              height: 35,
              width: 35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(Icons.close, color: Colors.grey),
            ),
            onTap: () {
              Get.back();
            },
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 50, width: double.infinity),
                        Wrap(
                          children: mapIkon.entries.map((e) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: e.key == valueSelected ? Colors.grey.shade400.withValues(alpha: 0.5) : Colors.transparent,
                              ),
                              child: IconButton(
                                icon: Icon(e.value, size: size),
                                color: color,
                                onPressed: () {
                                  Get.back<String>(result: e.key);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
                    ),
                    alignment: AlignmentDirectional.center,
                    child: const Text('Pilih Ikon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      isScrollControlled: true,
    );
  }

  static Future<Opsi?> bottomSheet({
    required List<Opsi> listOpsi,
    String valueSelected = "",
    bool withCari = true,
    String judul = "",
    Widget? tombol,
  }) {
    return Get.bottomSheet<Opsi>(
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              tombol ?? Container(),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(right: 15, bottom: 5, top: 40),
                  alignment: Alignment.center,
                  height: 35,
                  width: 35,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              // padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: DaftarOpsi(
                  listOpsi: listOpsi,
                  valueSelected: valueSelected,
                  withCari: withCari,
                  judul: judul,
                ),
              ),
            ),
          ),
        ],
      ),
      isScrollControlled: withCari,
    );
  }
}
