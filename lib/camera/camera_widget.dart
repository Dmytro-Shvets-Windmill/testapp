import 'dart:async';

import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:qr_code_scanner/src/qr_code_scanner.dart';

class CameraWidget extends StatefulWidget {
  final StreamSink<bool> permissionStreamSink;
  final QRViewCreatedCallback onQRViewCreated;
  final double bottomOffset;

  // ignore: use_key_in_widget_constructors
  const CameraWidget(
      this.permissionStreamSink, this.onQRViewCreated, this.bottomOffset);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  QRView? _lazyQRView;
  QRView get _qrView => _lazyQRView ??= QRView(
      key: GlobalKey(debugLabel: 'Test'),
      onQRViewCreated: widget.onQRViewCreated,
      permissionStreamSink: widget.permissionStreamSink,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 16,
          borderLength: 44,
          borderWidth: 1,
          cutOutSize: 100,
          cutOutBottomOffset: widget.bottomOffset));

  @override
  Widget build(BuildContext context) =>
      Column(children: [Expanded(flex: 5, child: _qrView)]);
}
