import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/shift_controller.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class FormPengajuanShift extends StatefulWidget {
  final List? dataForm;
  FormPengajuanShift({Key? key, this.dataForm}) : super(key: key);
  @override
  _FormPengajuanShiftState createState() => _FormPengajuanShiftState();
}

class _FormPengajuanShiftState extends State<FormPengajuanShift> {
  final _formKey = GlobalKey<FormState>();
  ShiftController controller = Get.put(ShiftController());
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var emId = AppData.informasiUser![0].em_id;
      if (widget.dataForm![1] == true) {
        controller.statusForm.value = true;
        controller.catatan.value.text = widget.dataForm![0]['uraian'];
        controller.idpengajuanShift.value =
            widget.dataForm![0]['id'].toString();
        controller.getUserInfo();
        controller.requestShiftDate.value.text =
            Constanst.convertDate9(widget.dataForm![0]['dari_tgl']);
        controller.requestShiftDate.refresh();
        controller.searchWorkSchedule(
            emId, controller.requestShiftDate.value.text, false);
        controller.replaceShiftDate.value.text =
            Constanst.convertDate9(widget.dataForm![0]['sampai_tgl']);
        controller.replaceShiftDate.refresh();
        if (controller.swap.value == true) {
          for (var employee in controller.infoEmployeeAll) {
            if (employee['full_name'] == widget.dataForm![0]['name_delegasi']) {
              controller.emIdSwap.value = employee['em_id'];
              controller.selectedEmployee.value = employee['full_name'];
              controller.searchWorkSchedule(controller.emIdSwap.value,
                  controller.replaceShiftDate.value.text, true);
            }
          }
          ;
        } else {
          controller.searchWorkSchedule(
              emId, controller.replaceShiftDate.value.text, true);
        }
      } else {
        controller.statusForm.value = false;
        controller.idpengajuanShift.value = '';
        controller.catatan.value.text = '';
        controller.requestShiftDate.value.text = '';
        controller.replaceShiftDate.value.text = '';
        controller.getUserInfo();
        var pola = DateFormat('yyyy-MM-dd');
        var attenDate = pola.format(controller.initialDate.value);
        controller.searchWorkSchedule(emId, attenDate, false);
        controller.searchWorkSchedule(emId, attenDate, true);
      }
    });
  }

  Future<void> _pickDate(BuildContext context, validate, initial) async {
    var dateSelect = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: initial,
      cancelText: 'Batal',
      confirmText: 'Simpan',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.dark(
              primary: Constanst.onPrimary,
              onPrimary: Constanst.colorWhite,
              onSurface: Constanst.fgPrimary,
              surface: Constanst.colorWhite,
            ),
            // useMaterial3: settings.useMaterial3,
            visualDensity: VisualDensity.standard,
            dialogTheme: const DialogTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)))),
            primaryColor: Constanst.fgPrimary,
            textTheme: TextTheme(
              titleMedium: GoogleFonts.inter(
                color: Constanst.fgPrimary,
              ),
            ),
            dialogBackgroundColor: Constanst.colorWhite,
            canvasColor: Colors.white,
            hintColor: Constanst.onPrimary,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Constanst.onPrimary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (dateSelect == null) {
      UtilsAlert.showToast("Tanggal tidak terpilih");
    } else {
      initial = dateSelect;
      print('ini initial date $initial}');
      var pola = DateFormat('yyyy-MM-dd');
      validate.value.text = pola.format(dateSelect);
      validate.refresh();
      print('ini tanggal terpilih ${validate.value.text}');
      var emid = AppData.informasiUser![0].em_id;
      if (validate == controller.requestShiftDate) {
        controller.searchWorkSchedule(emid, validate.value.text, false);
      } else {
        if (controller.swap.value == true) {
          controller.searchWorkSchedule(
              controller.emIdSwap.value, validate.value.text, true);
        } else {
          controller.searchWorkSchedule(emid, validate.value.text, true);
        }
      }
    }
  }

  void _submitForm() {
    if (controller.requestShiftDate.value.text.isEmpty) {
      print('Tanggal Tidak boleh kosong');
      return;
    }
    if (controller.replaceShiftDate.value.text.isEmpty) {
      print('Tanggal Tidak boleh kosong');
      return;
    }
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
    controller.kirimPengajuan(widget.dataForm![2]);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Pengajuan Shift'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Obx(() => dateSelect(context, 'Request Date*',
                  controller.requestShiftDate, controller.initialDate.value)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  divide(),
                  SizedBox(height: 16),
                  infoShift(controller.currentshiftShedule,
                      controller.currentListWorkSchedule, 'Current shift*'),
                  divide(),
                  SizedBox(height: 16),
                  Obx(() => dateSelect(
                      context,
                      'Replace Date*',
                      controller.replaceShiftDate,
                      controller.reInitialDate.value)),
                  divide(),
                  SizedBox(height: 16),
                  widget.dataForm![2] == true
                      ? swapShift()
                      : infoShift(
                          controller.employeeShiftShedule,
                          controller.employeeListWorkSchedule,
                          'Replace shift*'),
                  widget.dataForm![2] == true ? divide() : SizedBox(),
                  widget.dataForm![2] == true
                      ? SizedBox(height: 16)
                      : SizedBox(),
                  widget.dataForm![2] == true
                      ? infoShift(controller.employeeShiftShedule,
                          controller.employeeListWorkSchedule, 'Replace shift*')
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(
                      height: 0,
                      thickness: 1,
                      color: Constanst.fgBorder,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextLabell(
                      text: "Reason *",
                      color: Constanst.fgPrimary,
                      size: 14,
                      weight: FontWeight.w400,
                    ),
                  ),
                  TextFormField(
                    controller: controller.catatan.value,
                    decoration: InputDecoration(
                      hintText: '',
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Alasan wajib diisi'
                        : null,
                  ),
                  divide(),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
            color: Constanst.colorWhite,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2.0),
                blurRadius: 12.0,
              )
            ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
            child: ElevatedButton(
              onPressed: () {
                _submitForm();
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Constanst.colorWhite,
                  backgroundColor: Constanst.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
              child: Text(
                'Kirim',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Constanst.colorWhite),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InkWell dateSelect(BuildContext context, label, validate, initial) {
    return InkWell(
        onTap: () => _pickDate(context, validate, initial),
        child: InputDecorator(
          decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              suffixIcon: const Icon(Iconsax.calendar_2)),
          child: Text(
            validate.value.text.isEmpty
                ? 'Pilih tanggal'
                : Constanst.convertDate8(validate.value.text),
          ),
        ));
  }

  Padding divide() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Divider(
        height: 0,
        thickness: 1,
        color: Constanst.fgBorder,
      ),
    );
  }

  Obx infoShift(current, list, label) {
    return Obx(() {
      var time_in = '';
      var time_out = '';
      var name = '';
      if (current.value.isNotEmpty) {
        time_in = Constanst.convertTime(list[0]['time_in']);
        time_out = Constanst.convertTime(list[0]['time_out']);
        name = list[0]['name'];
      }
      return InputDecorator(
        decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderSide: BorderSide.none),
            suffixIcon: const Icon(Icons.arrow_drop_down)),
        child: Text(
          current.value.isEmpty
              ? 'Day off (00:00 - 00:00)'
              : '$name ($time_in - $time_out)',
        ),
      );
    });
  }

  Obx pilihShift() {
    return Obx(() {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Pilih Shift',
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        value: controller.shiftShedule.value,
        items:
            controller.listWorkSchedule.map<DropdownMenuItem<String>>((shift) {
          final timeIn = Constanst.convertTime(shift["time_in"]);
          final timeOut = Constanst.convertTime(shift["time_out"]);
          final name = shift["name"];
          final id = shift['id'];
          return DropdownMenuItem<String>(
            value: id.toString(),
            child: TextLabell(
              text: "$name ($timeIn - $timeOut)",
              color: Constanst.fgPrimary,
              size: 14,
              weight: FontWeight.w400,
            ),
          );
        }).toList(),
        onChanged: (value) {
          print('ini shift ${value}');
          controller.shiftShedule.value = value.toString();
          for (var shift in controller.listWorkSchedule) {
            if (shift['id'].toString() == value.toString()) {
              controller.dariJam.value.text = shift['time_in'];
              controller.sampaiJam.value.text = shift['time_out'];
            }
          }
          print('ini dari jam ${controller.dariJam.value.text}');
          print('ini sampai jam ${controller.sampaiJam.value.text}');
        },
        validator: (value) => value == null ? 'Silakan pilih shift' : null,
      );
    });
  }

  Obx swapShift() {
    return Obx(() {
      return DropdownSearch<String>(
        items: controller.infoEmployeeAll
            .map<String>((em) => em["full_name"] as String)
            .toList(),
        selectedItem: controller.selectedEmployee.value,
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              labelText: "Cari karyawan...",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: 'Tukar Shift dengan*',
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        onChanged: (value) {
          print('ini shift $value');
          controller.selectedEmployee.value = value!;
          for (var emp in controller.infoEmployeeAll) {
            if (emp['full_name'] == value) {
              var emId = emp['em_id'];
              controller.emIdSwap.value = emId;
              var attenDate = controller.replaceShiftDate.value.text;
              controller.searchWorkSchedule(emId, attenDate, true);
            }
          }
        },
        validator: (value) =>
            value == null || value.isEmpty ? 'Silakan pilih employee' : null,
      );
    });
  }
}
