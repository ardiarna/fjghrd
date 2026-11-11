import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

/// Komponen pembungkus PlutoGrid yang dioptimalkan untuk performa.
///
/// Menyelesaikan masalah `key: UniqueKey()` yang sebelumnya memaksa widget
/// dihancurkan dan dibuat ulang dari nol setiap kali data berubah.
///
/// Keuntungan:
/// 1. Tidak menghancurkan internal state PlutoGrid (posisi scroll, sort, dan active column filters tetap terjaga).
/// 2. Menghindari pemanggilan berulang `autoFitColumn` pada seluruh kolom yang memicu lag / frame drops.
/// 3. Sinkronisasi baris data baru dilakukan secara efisien via `stateManager`.
class AFPlutoGrid extends StatefulWidget {
  final List<PlutoColumn> columns;
  final List<PlutoRow> rows;
  final List<PlutoColumnGroup>? columnGroups;
  final void Function(PlutoGridOnLoadedEvent)? onLoaded;
  final void Function(PlutoGridOnChangedEvent)? onChanged;
  final void Function(PlutoGridOnSelectedEvent)? onSelected;
  final void Function(PlutoGridOnSortedEvent)? onSorted;
  final void Function(PlutoGridOnRowCheckedEvent)? onRowChecked;
  final void Function(PlutoGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final void Function(PlutoGridOnRowSecondaryTapEvent)? onRowSecondaryTap;
  final void Function(PlutoGridOnRowsMovedEvent)? onRowsMoved;
  final void Function(PlutoGridOnColumnsMovedEvent)? onColumnsMoved;
  final void Function(PlutoGridStateManager stateManager)? onRowsUpdated;
  final CreateHeaderCallBack? createHeader;
  final CreateFooterCallBack? createFooter;
  final Widget? noRowsWidget;
  final PlutoRowColorCallback? rowColorCallback;
  final PlutoColumnMenuDelegate? columnMenuDelegate;
  final PlutoGridConfiguration configuration;
  final PlutoGridMode mode;

  const AFPlutoGrid({
    super.key,
    required this.columns,
    required this.rows,
    this.columnGroups,
    this.onLoaded,
    this.onChanged,
    this.onSelected,
    this.onSorted,
    this.onRowChecked,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.onRowsMoved,
    this.onColumnsMoved,
    this.onRowsUpdated,
    this.createHeader,
    this.createFooter,
    this.noRowsWidget,
    this.rowColorCallback,
    this.columnMenuDelegate,
    this.configuration = const PlutoGridConfiguration(),
    this.mode = PlutoGridMode.normal,
  });

  @override
  State<AFPlutoGrid> createState() => _AFPlutoGridState();
}

class _AFPlutoGridState extends State<AFPlutoGrid> {
  PlutoGridStateManager? _stateManager;
  List<PlutoRow>? _pendingRows;

  @override
  void didUpdateWidget(covariant AFPlutoGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.rows, oldWidget.rows)) {
      if (_stateManager != null) {
        _syncRows(widget.rows);
      } else {
        _pendingRows = widget.rows;
      }
    }
  }

  void _syncRows(List<PlutoRow> newRows) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _stateManager == null) return;
      if (newRows.isEmpty) {
        _stateManager!.removeAllRows(notify: true);
        widget.onRowsUpdated?.call(_stateManager!);
        return;
      }

      // Simpan group rows yang sedang expanded sebelum baris diganti
      final Set<Key> expandedGroupKeys = {};
      final bool hasRowGroups = _stateManager!.enabledRowGroups;
      if (hasRowGroups) {
        for (final row in _stateManager!.iterateAllRowGroup) {
          if (row.type.group.expanded) {
            expandedGroupKeys.add(row.key);
          }
        }
      }

      _stateManager!.removeAllRows(notify: false);
      _stateManager!.appendRows(newRows);

      // Pulihkan group rows yang sebelumnya expanded
      if (hasRowGroups) {
        for (final row in [..._stateManager!.iterateAllRowGroup]) {
          if (row.type.isGroup && expandedGroupKeys.contains(row.key)) {
            if (!row.type.group.expanded) {
              _stateManager!.toggleExpandedRowGroup(
                rowGroup: row,
                notify: false,
              );
            }
          }
        }
        _stateManager!.notifyListeners();
      }

      widget.onRowsUpdated?.call(_stateManager!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: widget.columns,
      rows: widget.rows,
      columnGroups: widget.columnGroups,
      onLoaded: (event) {
        _stateManager = event.stateManager;
        if (_pendingRows != null) {
          final pending = _pendingRows!;
          _pendingRows = null;
          _syncRows(pending);
        }
        widget.onLoaded?.call(event);
      },
      onChanged: widget.onChanged,
      onSelected: widget.onSelected,
      onSorted: widget.onSorted,
      onRowChecked: widget.onRowChecked,
      onRowDoubleTap: widget.onRowDoubleTap,
      onRowSecondaryTap: widget.onRowSecondaryTap,
      onRowsMoved: widget.onRowsMoved,
      onColumnsMoved: widget.onColumnsMoved,
      createHeader: widget.createHeader,
      createFooter: widget.createFooter,
      noRowsWidget: widget.noRowsWidget,
      rowColorCallback: widget.rowColorCallback,
      columnMenuDelegate: widget.columnMenuDelegate,
      configuration: widget.configuration,
      mode: widget.mode,
    );
  }
}
