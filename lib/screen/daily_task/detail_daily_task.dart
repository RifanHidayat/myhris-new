import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/daily_task_controller.dart';
import 'package:siscom_operasional/screen/daily_task/form_daily_task.dart';
import 'package:siscom_operasional/utils/constans.dart';

class DetailDailyTask extends StatefulWidget {
  final int? id;

  const DetailDailyTask(this.id, {super.key});

  @override
  State<DetailDailyTask> createState() => _DetailDailyTaskState();
}

class _DetailDailyTaskState extends State<DetailDailyTask> {
  final controller = Get.find<DailyTaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: true,
        title: const Text("Detail Daily Task"),
      ),
      body: widget.id == null || widget.id == 0
          ? Center(child: Text('hari ini gak ada task, yuk kita bikin'))
          : descMasuk(),
    );
  }

  Widget buildStars(int level) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      if (i < level) {
        stars.add(Icon(Icons.star, size: 16, color: Colors.amber));
      } else {
        stars.add(Icon(Icons.star_border, size: 16, color: Colors.grey));
      }
    }
    return Row(children: stars);
  }

  Widget descMasuk() {
    return Obx(() {
      return controller.task.isEmpty
          ? const Center(child: Text('Tunggu Sebentar ya'))
          : ReorderableListView.builder(
              itemCount: controller.task.length,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex)
                  newIndex--; // Karena list bergeser saat dipindah
                final item = controller.task.removeAt(oldIndex);
                controller.task.insert(newIndex, item);
              },
              itemBuilder: (context, index) {
                final data = controller.task[index];

                int level = int.tryParse(data["level"].toString()) ?? 0;
                int status = int.tryParse(data['status'].toString()) ?? 0;

                List<String> difficultyLabels = [
                  "Tidak Diketahui",
                  "Sangat Mudah",
                  "Mudah",
                  "Normal",
                  "Sulit",
                  "Sangat Sulit"
                ];


                String difficultyLabel = level >= 1 && level <= 5
                    ? difficultyLabels[level]
                    : difficultyLabels[0];

                String statusLabel = status == 1 ? "Finished" : "Ongoing";
                Color statusColor = status == 1 ? Colors.green : Colors.orange;

                return ListTile(
                  key: ValueKey(data), // Wajib untuk ReorderableListView
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['judul'],
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        data['rincian'],
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          level >= 1 && level <= 5
                              ? buildStars(level)
                              : Icon(Icons.help_outline,
                                  size: 18, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            difficultyLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      if (status == 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'Selesai Pada: ${Constanst.convertDate(data['tgl_finish'])}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      const SizedBox(height: 6),
                      if (index != controller.task.length - 1)
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.fgBorder,
                        ),
                    ],
                  ), // Ikon drag
                );
              },
            );
    });
  }
}
