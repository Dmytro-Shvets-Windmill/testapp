import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testapp/camera/camera_widget.dart';

import 'camera_view_model.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraState();
}

class _CameraState extends State<CameraPage>
    with RouteAware, WidgetsBindingObserver {
  late CameraViewModel viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = onCreateViewModel(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && Platform.isIOS) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraView = CameraWidget(viewModel.permissionStreamSink,
        viewModel.onQRViewCreated, -kToolbarHeight);
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Test')),
        body: cameraView);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    if (Platform.isIOS) {
      setState(() {
        viewModel.controller.resumeCamera();
      });
    } else {
      viewModel.controller.setOvershadowed(false);
      viewModel.controller.resumeCamera();
    }
  }

  @override
  void didPushNext() {
    if (Platform.isAndroid) {
      viewModel.controller.setOvershadowed(true);
      viewModel.controller.pauseCamera();
    }
    super.didPushNext();
  }

  CameraViewModel onCreateViewModel(BuildContext context) {
    final viewModel = CameraViewModel();
    _subscribeQRStream(viewModel.qrString);
    return viewModel;
  }

  void _subscribeQRStream(Stream<String> qrString) {
    qrString.asyncMap(_onScanData).listen((scanData) {
      if (ModalRoute.of(context)?.isCurrent == true) {
        if (kDebugMode) {
          print(scanData);
        }
      }
    });
  }

  Future<String> _onScanData(String event) {
    viewModel.controller.pauseCamera();
    return Future.delayed(const Duration(milliseconds: 500), () => event);
  }
}
