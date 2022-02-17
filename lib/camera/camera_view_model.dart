import 'dart:async';
// ignore: implementation_imports
import 'package:qr_code_scanner/src/qr_code_scanner.dart';

class CameraViewModel {
  final _permissionController = StreamController<bool>.broadcast();

  StreamSink<bool> get permissionStreamSink => _permissionController.sink;
  late QRViewController controller;

  CameraViewModel();

  final _qrStringController = StreamController<String>.broadcast();

  Stream<String> get qrString => _qrStringController.stream;

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(_qrStringController.add);
  }

  void dispose() {
    _qrStringController.close();
    _permissionController.close();
  }

  void subscribeOnCameraPermission(
      StreamSink<bool> parentPermissionStreamSink) {
    _permissionController.stream.listen((isGranted) {
      parentPermissionStreamSink.add(isGranted);
    });
  }
}
