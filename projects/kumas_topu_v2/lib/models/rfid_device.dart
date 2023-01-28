class RFIDDevice {
  ///RFID cihazının aktif olup olmadığını kontrol ettiğimiz yer
  final String? rfidConnectStatus;

  RFIDDevice(this.rfidConnectStatus);

  @override
  String toString() {
    return 'RFIDDevice{rfidDeviceName: $rfidConnectStatus}';
  }
}
