import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

abstract class AFplutogridConfig {
  static PlutoGridConfiguration configSatu({double iconSize = 18}) {
    return PlutoGridConfiguration(
      enableMoveHorizontalInEditing: true,
      scrollbar: const PlutoGridScrollbarConfig(
        isAlwaysShown: true,
        onlyDraggingThumb: false,
        scrollbarThickness: 15,
        scrollbarThicknessWhileDragging: 15,
        hoverWidth: 100,
      ),
      localeText: const PlutoGridLocaleText(
        filterColumn: 'Kolom Pencarian',
        filterAllColumns: 'Semua Kolom',
        filterType: 'Tipe Pencarian',
        filterValue: 'Nilai / Kata Dicari',
        filterContains: '🔍 cari',
        filterEquals: '🔍 cari sama dengan',
        filterStartsWith: '🔍 cari dimulai dengan',
        filterEndsWith: '🔍 cari diakhiri dengan',
        filterGreaterThan: '🔍 lebih besar dari',
        filterGreaterThanOrEqualTo: '🔍 lebih besar dari atau =',
        filterLessThan: '🔍 lebih kecil dari',
        filterLessThanOrEqualTo: '🔍 lebih kecil dari atau =',
        loadingText: 'Mohon tunggu...',
        sunday: 'Mg',
        monday: 'Sn',
        tuesday: 'Sl',
        wednesday: 'Rb',
        thursday: 'Km',
        friday: 'Jm',
        saturday: 'Sb',
      ),
      style: PlutoGridStyleConfig(
        rowHeight: 30,
        columnHeight: 35,
        borderColor: Colors.brown.shade200,
        gridBorderColor: Colors.transparent,
        gridBackgroundColor: Colors.transparent,
        defaultColumnFilterPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        iconSize: iconSize,
      ),
    );
  }

  static PlutoGridConfiguration configDua({double iconSize = 18}) {
    return PlutoGridConfiguration(
      enableMoveHorizontalInEditing: true,
      scrollbar: const PlutoGridScrollbarConfig(
        isAlwaysShown: true,
        onlyDraggingThumb: false,
        scrollbarThickness: 15,
        scrollbarThicknessWhileDragging: 15,
        hoverWidth: 100,
      ),
      localeText: const PlutoGridLocaleText(
        filterColumn: 'Kolom Pencarian',
        filterAllColumns: 'Semua Kolom',
        filterType: 'Tipe Pencarian',
        filterValue: 'Nilai / Kata Dicari',
        filterContains: '🔍 cari',
        filterEquals: '🔍 cari sama dengan',
        filterStartsWith: '🔍 cari dimulai dengan',
        filterEndsWith: '🔍 cari diakhiri dengan',
        filterGreaterThan: '🔍 lebih besar dari',
        filterGreaterThanOrEqualTo: '🔍 lebih besar dari atau =',
        filterLessThan: '🔍 lebih kecil dari',
        filterLessThanOrEqualTo: '🔍 lebih kecil dari atau =',
        loadingText: 'Mohon tunggu...',
        sunday: 'Mg',
        monday: 'Sn',
        tuesday: 'Sl',
        wednesday: 'Rb',
        thursday: 'Km',
        friday: 'Jm',
        saturday: 'Sb',
      ),
      style: PlutoGridStyleConfig(
        rowHeight: 30,
        columnHeight: 35,
        borderColor: Colors.brown.shade200,
        gridBorderColor: Colors.transparent,
        gridBackgroundColor: Colors.transparent,
        defaultColumnFilterPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        iconSize: iconSize,
      ),
      columnSize: const PlutoGridColumnSizeConfig(
        autoSizeMode: PlutoAutoSizeMode.scale,
      ),
    );
  }
}