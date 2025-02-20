import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NFCReaderScreen(),
    );
  }
}

class NFCReaderScreen extends StatefulWidget {
  const NFCReaderScreen({super.key});

  @override
  State<NFCReaderScreen> createState() => _NFCReaderScreenState();
}

class _NFCReaderScreenState extends State<NFCReaderScreen> {
  List<String> _nfcIds = [];
  bool _isScanning = false;
  double _progressValue = 0.0;
  Color _statusColor = Colors.blue;
  String _statusText = 'Tekan tombol untuk memulai pemindaian';
  
  @override
  void initState() {
    super.initState();
    _checkNFCAvailability();
  }
  
  void _checkNFCAvailability() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable){
      setState(() {
        _nfcIds.add('NFC tidak tersedia pada perangkat ini');
      });
    }
  }

  void _startNFCScan(){
    if (_isScanning) return;
    setState(() {
      _isScanning = true;
      _progressValue = 0.2;
      _statusColor = Colors.orange;
      _statusText = 'Scanning NFC...';
    });
  }

  void _stopNFCScan() async {
    await NfcManager.instance.stopSession();
    setState(() {
      _isScanning = false;
      _progressValue = 0.0;
      _statusColor = Colors.blue;
      _statusText = 'Tekan tombol untuk memulai pemindaian';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NFC Reader'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _statusColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _statusText,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
            SizedBox(height: 20,),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isScanning ? Colors.orangeAccent : Colors.grey
              ),
              child: Icon(Icons.nfc, size: 50, color: Colors.white,),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}