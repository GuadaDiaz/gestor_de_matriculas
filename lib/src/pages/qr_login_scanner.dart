import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRLoginScanner extends StatefulWidget {
  const QRLoginScanner({super.key});

  @override
  State<QRLoginScanner> createState() => _QRLoginScannerState();
}

class _QRLoginScannerState extends State<QRLoginScanner> {
  bool isScanning = true;
  String? scanResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR para entrar')),
      body: MobileScanner(
        // Desactivar el escaneo si ya encontramos un resultado
        key: ValueKey(isScanning),
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          
          if (barcodes.isNotEmpty && isScanning) {
            final code = barcodes.first.rawValue;
            
            if (code != null) {
              setState(() {
                scanResult = code;
                isScanning = false; // Detener escaneo después del primer éxito
              });
              
              // Devuelve el resultado a la pantalla de Login
              Navigator.pop(context, scanResult); 
            }
          }
        },
      ),
    );
  }
}
