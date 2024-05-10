import 'package:fjghrd/utils/af_constant.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

abstract class AFwidget {

  static Widget appBarFlexibleSpace({double? height, double? width}) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.green],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/coret.png'),
          fit: BoxFit.cover,
          alignment: AlignmentDirectional.center,
        ),
      ),
    );
  }

  static Widget footer() {
    return Container(
      alignment: AlignmentDirectional.bottomStart,
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
      child: Text(
        'CatatDuit by Artoviris',
        style: TextStyle(fontSize: 10, color: Get.theme.primaryColor),
      ),
    );
  }

  static Widget handleScroll() {
    return Container(
      height: 5,
      width: 55,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  static Widget iconButon({required void Function()? onPressed, Icon icon = const Icon(Icons.add)}) {
    return IconButton(
      onPressed: onPressed,
      icon: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle
        ),
        child: icon,
      ),
    );
  }

  static Widget circularProgress({
    double? nilai,
    Color? warna,
    String? keterangan,
    double tinggi = 45,
    double lebar = 45,
  }) {
    warna = warna ?? Get.theme.primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: tinggi,
            width: lebar,
            margin: const EdgeInsets.all(5),
            child: CircularProgressIndicator(
              value: nilai,
              strokeWidth: 3.7,
              color: warna,
            ),
          ),
        ),
        keterangan != null
            ? Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  keterangan,
                  style: TextStyle(color: warna),
                ),
              )
            : Container(),
      ],
    );
  }

  static Future<void> loading() {
    return Get.dialog(
      AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: circularProgress(
          keterangan: 'Mohon tunggu...',
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.grey.withOpacity(0.7),
    );
  }

  static Widget linearProgress({double? value, String? text, Color? color, Color? backgroudColor, Color? textColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: backgroudColor,
                color: color,
                minHeight: 15,
              ),
            ),
            text != null
                ? Text(text, style: TextStyle(fontSize: 12, color: textColor))
                : value != null
                ? Text('${(value*100).toInt()}%', style: TextStyle(fontSize: 12, color: textColor))
                : Container(),
          ],
        ),
      ],
    );
  }

  static Widget ikon(
    String ikon, {
    Color? color,
    double? size,
  }) {
    return Icon(
      mapIkon[ikon] ?? Icons.arrow_circle_down,
      color: color,
      size: size,
    );
  }

  static Widget networkImage(String? url,
      {BoxFit? fit,
      double? width,
      double? height,
      Alignment alignment = Alignment.center,
      ImageRepeat repeat = ImageRepeat.noRepeat}) {
    if (url != null && url != '') {
      return Image.network(
        url,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        repeat: repeat,
      );
    } else {
      return Container(
        width: width,
        height: height,
        color: Colors.white,
        alignment: AlignmentDirectional.center,
        child: Image.asset(
          'assets/images/loading.gif',
          width: 50,
          height: 50,
        ),
      );
    }
  }

  static Future<void> dialog(Widget konten, {
    bool scrollable = true,
    bool barrierDismissible = true,
    EdgeInsetsGeometry? contentPadding,
    Color? backgroundColor,
  }) {
    return Get.dialog(
      AlertDialog(
        content: konten,
        scrollable: scrollable,
        contentPadding: contentPadding,
        backgroundColor: backgroundColor,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static dynamic snackbar(String message, {String title = ''}) {
    return Get.snackbar(title, message,
        backgroundColor: Colors.brown, colorText: Colors.white);
  }

  static Future<String?> bottomSheet(Widget konten, {bool fullHeight = false}) {
    return Get.bottomSheet<String>(
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(
                  right: 15, bottom: 10, top: fullHeight ? 40 : 0),
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
              child: konten,
            ),
          ),
        ],
      ),
      isScrollControlled: fullHeight,
    );
  }

  static Future<XFile?> pickImage(
      {required BuildContext context,
      bool withoutCrop = false,
      bool fromCamera = false}) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 720,
      maxHeight: 720,
      imageQuality: 70,
    );
    return pickedFile;
  }

  static Future<XFile?> bottomPickImage({required BuildContext context, bool withoutCrop = false}) async {
    return Get.bottomSheet<XFile>(
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: GestureDetector(
              child: Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Container(
                  margin: const EdgeInsets.only(right: 15, bottom: 10),
                  alignment: Alignment.center,
                  height: 35,
                  width: 35,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.close),
                ),
              ),
              onTap: () {
                Get.back();
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
            ),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.add_a_photo_outlined),
                  title: const Text('Ambil gambar dengan kamera'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.grey,
                  ),
                  onTap: () async {
                    var a = await AFwidget.pickImage(
                      context: context,
                      withoutCrop: withoutCrop,
                      fromCamera: true,
                    );
                    Get.back(result: a);
                  },
                ),
                const Divider(),
                ListTile(
                  dense: true,
                  leading: const Icon(
                      Icons.add_photo_alternate_outlined),
                  title: const Text('Pilih gambar dari gallery'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.grey,
                  ),
                  onTap: () async {
                    var a = await AFwidget.pickImage(
                      context: context,
                      withoutCrop: withoutCrop,
                      fromCamera: false,
                    );
                    Get.back(result: a);
                  },
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<DateTime?> pickDate({
    required BuildContext context,
    DateTime? initialDate,
    bool isTime = false,
  }) async {
    DateTime tanggalInisial = initialDate ?? DateTime.now();
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return showCupertinoModalPopup<DateTime?>(
        context: context,
        builder: (_) {
          DateTime? tgl;
          return Container(
            height: 251,
            // margin: EdgeInsets.only(
            //   bottom: MediaQuery.of(context).viewInsets.bottom,
            // ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: CupertinoDatePicker(
                      initialDateTime: tanggalInisial,
                      mode: isTime
                          ? CupertinoDatePickerMode.time
                          : CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      onDateTimeChanged: (value) {
                        tgl = value;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Cancel'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: TextButton(
                          onPressed: () async {
                            Get.back<DateTime>(result: tgl);
                          },
                          child: const Text('OK'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      if (isTime) {
        var a = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: tanggalInisial.hour,
            minute: tanggalInisial.minute,
          ),
          builder: (context, child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child ?? Container(),
            );
          },
        );
        if (a != null) {
          return DateTime(tanggalInisial.year, tanggalInisial.month,
              tanggalInisial.day, a.hour, a.minute);
        } else {
          return null;
        }
      } else {
        return await showDatePicker(
          context: context,
          initialDate: tanggalInisial,
          firstDate: DateTime(1947),
          lastDate: DateTime(DateTime.now().year + 100),
        );
      }
    }
  }

  static Widget textField({
    TextEditingController? controller,
    String? label,
    FloatingLabelBehavior? floatingLabelBehavior,
    bool readOnly = false,
    bool enabled = true,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? prefix,
    Widget? suffix,
    Function()? ontap,
    Function(String)? onchanged,
    FocusNode? focusNode,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? inputformatters,
    bool obscureText = false,
    Color? backgroudColor,
    int? minLines = 1,
    int? maxLines = 1,
    EdgeInsetsGeometry? contentPadding,
    double marginTop = 11,
    double marginBottom = 0,
    double marginRight = 0,
    double marginLeft = 0,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroudColor,
        borderRadius:
        const BorderRadius.all(Radius.circular(7)),
        // border: Border.all(color: Colors.black.withOpacity(0.2)),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.5),
        //     spreadRadius: 0.3,
        //     blurRadius: 0.3,
        //     offset: const Offset(0.5, 0.5),
        //   ),
        // ],
      ),
      margin: EdgeInsets.fromLTRB(marginLeft, marginTop, marginRight, marginBottom),
      // padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label ?? '',
          floatingLabelBehavior: floatingLabelBehavior,
          // labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          prefix: prefix,
          suffix: suffix,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          alignLabelWithHint: true,
          // border: InputBorder.none,
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            borderSide: BorderSide(color: Color(0xFFd1d1d1)),
          ),
          contentPadding: contentPadding,
          isDense: true,
        ),
        readOnly: readOnly,
        enabled: enabled,
        keyboardType: keyboard,
        inputFormatters: inputformatters,
        focusNode: focusNode,
        onTap: ontap,
        onChanged: onchanged,
        obscureText: obscureText,
        minLines: minLines,
        maxLines: maxLines,
        textAlign: textAlign,
      ),
    );
  }

  static Widget comboField({required String value, required String label, void Function()? onTap, IconData? prefixIcon}) {
    if(value == '') {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        // margin: const EdgeInsets.only(top: 11),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFd1d1d1)),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20)
            ],
          ),
        ),
      );
    }
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          // margin: const EdgeInsets.only(top: 11),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFd1d1d1)),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                prefixIcon != null ?
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(prefixIcon, color: Colors.grey, size: 20),
                ) : Container(),
                Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20)
              ],
            ),
          ),
        ),
        label != '' ?
        Container(
          margin: const EdgeInsets.only(top: 5, left: 7),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          color: Colors.white,
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ) :
        Container(),
      ],
    );
  }

  static Widget tombol({required String label,
    required Function()? onPressed,
    Size? minimumSize,
    Color? color,
    bool withContainer = false,
  }) {
    var a = FilledButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: minimumSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(label),
    );
    if(withContainer) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow:  [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: a,
      );
    }
    return a;
  }

  static Future<void> formHapus({
    required String label,
    required Function()? aksi,
  }) {
    return Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        scrollable: true,
        // elevation: 0,
        content: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Apakah Kamu Yakin?',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 20),
                    child: Text(
                        'Ingin menghapus $label? Data yang telah terhapus tidak dapat dikembalikan lagi.'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: tombol(
                          label: 'BATAL',
                          color: Colors.orangeAccent,
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(right: 10)),
                      Expanded(
                        child: tombol(
                          label: 'YA',
                          color: Colors.red,
                          onPressed: aksi,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              margin: const EdgeInsets.only(top: 15),
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(7),
                  topLeft: Radius.circular(7),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: const Icon(Icons.delete_forever_outlined,
                  color: Colors.white),
            ),
          ],
        ),
        // contentPadding: const EdgeInsets.all(0),
      ),
      barrierDismissible: true,
    );
  }

  static Widget table2column({required List<String> columnOne, required List<String> columnTwo}) {
    int idx = -1;
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      columnWidths: const {
        0: FixedColumnWidth(100),
        1: FixedColumnWidth(15),
      },
      children: columnOne.map((c1) {
        idx++;
        return TableRow(
          children: [
            Text(c1,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
            Text(':',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(columnTwo[idx],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  static Widget photoBox({required Widget child}) {
    return InteractiveViewer(
      child: DottedBorder(
        padding: const EdgeInsets.all(5),
        color: const Color(0xFFd1d1d1),
        strokeWidth: 1.3,
        dashPattern: const [10,7],
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: child,
        ),
      ),
    );
  }

  static Widget noData({String label = 'Tidak ada data'}) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Text(label),
      ),
    );
  }

}
