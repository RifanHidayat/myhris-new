import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';

class SignaturePage extends StatefulWidget {
  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Uint8List? signatureImage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSignature() {
    _controller.clear();
    setState(() {
      signatureImage = null;
    });
  }

  Future<void> _saveSignature() async {
    if (_controller.isNotEmpty) {
      final data = await _controller.toPngBytes();
      if (data != null) {
        setState(() {
          signatureImage = data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tanda Tangan Digital")),
      body: Column(
        children: [
          Container(
            height: 300,
            color: Colors.grey[200],
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: _clearSignature, child: Text("Bersihkan")),
              ElevatedButton(onPressed: _saveSignature, child: Text("Simpan")),
            ],
          ),
          if (signatureImage != null)
            Column(
              children: [
                SizedBox(height: 20),
                Text("Hasil Tanda Tangan:"),
                Image.memory(signatureImage!, height: 150),
              ],
            ),
        ],
      ),
    );
  }
}
