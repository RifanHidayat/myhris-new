import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/change_log_controller.dart';

import '../../utils/constans.dart';

class ChangeLogPage extends StatelessWidget {
  final ChangeLogController controller = Get.put(ChangeLogController());

  ChangeLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight) * 1,
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            )
          ]),
          child: AppBar(
            backgroundColor: Constanst.colorWhite,
            elevation: 0,
            leadingWidth: 50,
            titleSpacing: 0,
            centerTitle: false,
            title: Text(
              "Change Log",
              style: GoogleFonts.inter(
                  color: Constanst.fgPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            leading: IconButton(
              icon: Icon(
                Iconsax.arrow_left,
                color: Constanst.fgPrimary,
                size: 24,
              ),
              onPressed: Get.back,
            ),
          ),
        ),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.changeLogs.length,
          itemBuilder: (context, index) {
            final changeLog = controller.changeLogs[index];

            RxBool isExpanded = false.obs;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        Text('Versi: ${changeLog.nama}'),
                        const SizedBox(width: 8),
                        if (changeLog.nama == controller.namaVersi.value)
                          Icon(Icons.check_circle,
                              color: Constanst.infoLight, size: 18),
                      ],
                    ),
                    subtitle: Text(
                      'Tanggal: ${DateFormat('d MMMM yyyy', 'id').format(DateTime.parse(changeLog.tanggal))}',
                    ),
                    trailing: Obx(
                      () => IconButton(
                        icon: Icon(
                          isExpanded.value
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right,
                          color: Constanst.fgPrimary,
                        ),
                        onPressed: () {
                          isExpanded.toggle();
                        },
                      ),
                    ),
                    onTap: () {
                      isExpanded.toggle();
                    },
                  ),
                  Obx(() => isExpanded.value
                      ? Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8.0),
                              const Text('Pembaharuan Aplikasi:'),
                              ...changeLog.deskripsiList.map((descItem) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('- $descItem'),
                                );
                              }).toList(),
                            ],
                          ),
                        )
                      : Container()),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0),
                    child: Divider(
                      height: 0,
                      thickness: 1,
                      color: Constanst.colorNeutralBgTertiary,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
