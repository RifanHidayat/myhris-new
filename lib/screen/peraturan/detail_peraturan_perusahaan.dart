import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:siscom_operasional/model/peraturan_perusahaan_model.dart';

class DetailPeraturanPerusahaan extends StatelessWidget {
  final Peraturan peraturan;

  DetailPeraturanPerusahaan({required this.peraturan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${peraturan.title}",
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(children: [
          HtmlWidget(
            """
                <p style='font-size: 16px; text-align: center;'>
                  ${peraturan.keterangan}
                  </p>
                  """,
          ),
        ]),
      ),
    );
  }
}
