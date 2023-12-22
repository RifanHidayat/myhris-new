import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/approval_controller.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/screen/pesan/detail_approval.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';

class Approval extends StatefulWidget {
  String? title, bulan, tahun;
  Approval({Key? key, this.title, this.bulan, this.tahun}) : super(key: key);
  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  var controller = Get.put(ApprovalController());

  @override
  void initState() {
    controller.startLoadData(widget.title, widget.bulan, widget.tahun);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      appBar: AppBar(
          backgroundColor: Constanst.colorPrimary,
          automaticallyImplyLeading: false,
          elevation: 2,
          flexibleSpace: Obx(
            () => AppbarMenu1(
              title: "Menyetujui ${controller.titleAppbar.value}",
              colorTitle: Colors.white,
              colorIcon: Colors.white,
              iconShow: true,
              icon: 1,
              onTap: () {
                print("tes tes");
                var pesanController = Get.find<PesanController>();
                pesanController.loadApproveInfo();
                pesanController.loadApproveHistory();
                Get.back();
              },
            ),
          )),
      body: WillPopScope(
          onWillPop: () async {
            var pesanController = Get.find<PesanController>();
            pesanController.loadApproveInfo();
            pesanController.loadApproveHistory();
            Get.back();
            return true;
          },
          child: SafeArea(
            child: Obx(
              () => Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    pencarianData(),
                    SizedBox(
                      height: 16,
                    ),
                    Flexible(
                        flex: 3,
                        child: controller.listData.value.isEmpty
                            ? Center(
                                child: Text(controller.loadingString.value),
                              )
                            : listDataApproval())
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget pencarianData() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: Constanst.borderStyle2,
          border: Border.all(color: Constanst.colorNonAktif)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 15,
            child: Padding(
              padding: const EdgeInsets.only(top: 7, left: 10),
              child: Icon(Iconsax.search_normal_1),
            ),
          ),
          Expanded(
            flex: 85,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 85,
                      child: TextField(
                        controller: controller.cari.value,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Cari"),
                        style: TextStyle(
                            fontSize: 14.0, height: 1.0, color: Colors.black),
                        onChanged: (value) {
                          controller.cariData(value);
                        },
                      ),
                    ),
                    !controller.statusCari.value
                        ? SizedBox()
                        : Expanded(
                            flex: 15,
                            child: IconButton(
                              icon: Icon(
                                Iconsax.close_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                controller.statusCari.value = false;
                                controller.cari.value.text = "";
                                controller.startLoadData(
                                    widget.title, widget.bulan, widget.tahun);
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listDataApproval() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: controller.listData.value.length,
        itemBuilder: (context, index) {
          var data = controller.listData[index];
          var idx = controller.listData.value[index]['id'];
          var namaPengaju = controller.listData.value[index]['nama_pengaju'];
          var emIdPengaju = controller.listData.value[index]['emId_pengaju'];
          var delegasi = controller.listData.value[index]['delegasi'];
          var typeAjuan = controller.listData.value[index]['type'];
          var namaApprove1 = controller.listData.value[index]['nama_approve1'];
          var leave_status = controller.listData.value[index]['leave_status'];
          var dariJam = controller.listData.value[index]['dari_jam'];
          var sampaiJam = controller.listData.value[index]['sampai_jam'];
          var nomor_ajuan = controller.listData.value[index]['nomor_ajuan'];
          var tanggalPengajuan =
              controller.listData.value[index]['waktu_pengajuan'];
          return data['type'] == "payroll"
              ? Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      showDataDepartemenAkses(index: index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: HexColor('#A9B9CC')),
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 15,
                                child: Image.asset('assets/avatar.png'),
                              ),
                              Expanded(
                                  flex: 70,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextLabell(
                                          text: data['full_name'].toString(),
                                          weight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 1,
                                        ),
                                        TextLabell(
                                          text: data['nama_divisi'].toString(),
                                          color: Constanst.secondary,
                                        )
                                      ],
                                    ),
                                  )),
                              Expanded(
                                  flex: 20,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: HexColor('#FEF9E6'),
                                    ),
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, top: 4, bottom: 4),
                                    child: TextLabell(
                                      text: "Pending",
                                      color: HexColor('#744102'),
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Divider(),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 90,
                                child: TextLabell(
                                  text: data['catatan'].toString(),
                                  color: Constanst.Secondary,
                                ),
                              ),
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Constanst.Secondary,
                                      size: 15,
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Divider(),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Icon(
                                Iconsax.timer,
                                color: HexColor('#F2AA0D'),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              TextLabell(
                                text: "Pending approval by ${data['em_email']}",
                                size: 14,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : data['type'] == "absensi"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Text("${Constanst.convertDate2("$tanggalPengajuan")}"),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: Constanst.borderStyle2,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 170, 170, 170)
                                    .withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset:
                                    Offset(1, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8, right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 70,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              nomor_ajuan.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              namaPengaju,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: controller.valuePolaPersetujuan ==
                                                              1 ||
                                                          controller
                                                                  .valuePolaPersetujuan ==
                                                              "1"? 30:55,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          color: Constanst.colorBGPending,
                                          borderRadius: Constanst.borderStyle1,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 3,
                                              right: 3,
                                              top: 5,
                                              bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                               Icon(
                                                      Iconsax.timer,
                                                      color: Constanst.color3,
                                                      size: 14,
                                                    ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3),
                                                child: Text(
                                                   controller.valuePolaPersetujuan ==
                                                              1 ||
                                                          controller
                                                                  .valuePolaPersetujuan ==
                                                              "1"
                                                      ? '$leave_status'
                                                      : leave_status ==
                                                              "Pending"
                                                          ? "Pending Approve1"
                                                          : "Pending Approve2",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Constanst.color3),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 50,
                                      child: Text(
                                        "Checkin ${dariJam ?? "_ _ : _ _"}",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 50,
                                      child: Text(
                                        "Checkout ${sampaiJam ?? "_ _ : _ _"}",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                namaApprove1 == "" || leave_status == "Pending"
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                namaApprove1 == "" || leave_status == "Pending"
                                    ? SizedBox()
                                    : Center(
                                        child: Text(
                                          "Approve 3 by - $namaApprove1",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(DetailApproval(
                                      emId: emIdPengaju,
                                      title: typeAjuan,
                                      idxDetail: "$idx",
                                      delegasi: delegasi,
                                    ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Constanst.colorPrimary,
                                        borderRadius: Constanst.borderStyle2),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Center(
                                        child: Text(
                                          "Lihat Detail",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Text("${Constanst.convertDate2("$tanggalPengajuan")}"),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: Constanst.borderStyle2,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 170, 170, 170)
                                    .withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset:
                                    Offset(1, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8, right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 70,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          namaPengaju,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: controller.valuePolaPersetujuan ==
                                                              1 ||
                                                          controller
                                                                  .valuePolaPersetujuan ==
                                                              "1"? 30:55,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          color: Constanst.colorBGPending,
                                          borderRadius: Constanst.borderStyle1,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 3,
                                              right: 3,
                                              top: 5,
                                              bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                      Iconsax.timer,
                                                      color: Constanst.color3,
                                                      size: 14,
                                                    ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3),
                                                child: Text(
                                                  controller.valuePolaPersetujuan ==
                                                              1 ||
                                                          controller
                                                                  .valuePolaPersetujuan ==
                                                              "1"
                                                      ? '$leave_status'
                                                      : leave_status ==
                                                              "Pending"
                                                          ? "Pending Approve1"
                                                          : "Pending Approve2",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Constanst.color3),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "$typeAjuan",
                                  style: TextStyle(fontSize: 14),
                                ),
                                namaApprove1 == "" || leave_status == "Pending"
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                namaApprove1 == "" || leave_status == "Pending"
                                    ? SizedBox()
                                    : Center(
                                        child: Text(
                                          "Approve 1 by - $namaApprove1",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(DetailApproval(
                                      emId: emIdPengaju,
                                      title: typeAjuan,
                                      idxDetail: "$idx",
                                      delegasi: delegasi,
                                    ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Constanst.colorPrimary,
                                        borderRadius: Constanst.borderStyle2),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Center(
                                        child: Text(
                                          "Lihat Detail",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
        });
  }

  showDataDepartemenAkses({index}) {
    var data = controller.listData[index];
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: HexColor('#CBD5E0')),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextLabell(
                        text: "Tanggal Pengajuan",
                        weight: FontWeight.bold,
                      ),
                      TextLabell(
                        text:
                            "${Constanst.convertDate2(data['waktu_pengajuan'])}",
                        color: Constanst.secondary,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: HexColor('#CBD5E0')),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextLabell(
                            text: "Nama pengajuan",
                            weight: FontWeight.bold,
                          ),
                          TextLabell(
                            text: data['full_name'],
                            color: Constanst.secondary,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider(),
                      SizedBox(
                        height: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextLabell(
                            text: "Keterangan",
                            weight: FontWeight.bold,
                          ),
                          TextLabell(
                            text: data['catatan'],
                            color: Constanst.secondary,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: HexColor('#CBD5E0'),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Center(
                            child: TextLabell(
                              text: "Batalkan",
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 50,
                        child: InkWell(
                          onTap: () {
                            controller
                                .arppovalpayroll(id: data['id'])!
                                .then((value) {
                              if (value == true) {
                                print("tes tes");
                                var pesanController =
                                    Get.find<PesanController>();
                                pesanController.loadApproveInfo();
                                pesanController.loadApproveHistory();
                                Get.back();
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Constanst.colorPrimary,
                              border: Border.all(
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Center(
                              child: TextLabell(
                                text: "Approve",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          );
        });
  }
}
