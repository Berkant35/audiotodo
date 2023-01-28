part of 'native_manager.dart';

enum ChannelKeys { mainChannel, mainSupportChannel, eventChannel, scanToMatchEventChannel,inventoryEventChannel }

///Invoke methodların tiplerini topladığımız enum
enum InvokeMethods {
  init,
  stopInventory,
  continueInventory,
  clearInventory,
  playSound,
  setPower,
  getPower,
  scanBarcode,
  startInventory,
  scanBarcodeButton,
  setScanToMatchStatus,
  singleInventory,
  initInventory,
  barcodeModeOn,
  writeEpc
}

enum BroadCastStates { inventoryAndGetTag,scanToMatchAndGetTagWithBarcodeNumber,listenTriggerForWrite}

enum RFIDStatus { connected, disconnected }

abstract class NativeInterface {
  ///Flutter --> JAVA

  ///method channel sadece gidip bir tane veri getirdiğimiz method.
  ///Örnek: connect RFID Device initalize yaptığımız durumu kontrol etmemizi sağlar.
  final MethodChannel _methodChannel =
      MethodChannel(ChannelKeys.mainChannel.name);

  final MethodChannel _methodSupportChannel =
  MethodChannel(ChannelKeys.mainSupportChannel.name);

  /// event channel javadaki değişiklikleri dinlemememizi sağlayan kısım
  /// Örnek button basılınca eğer bir tag yakalanmadıysa SEARCH State aktif olur.
  final EventChannel _eventChannel =
      EventChannel(ChannelKeys.eventChannel.name);

  final EventChannel _inventoryEventChannel =
  EventChannel(ChannelKeys.inventoryEventChannel.name);

  ///Barcode okuması ve rfid etiketi okuma caselerini buradan haberleşerek yapıcaz
  final EventChannel _scanToMatchEventChannel =
  EventChannel(ChannelKeys.scanToMatchEventChannel.name);

  ///Initialize RFID...
  Future<RFIDDevice?> connectRFIDDevice();


  ///Inventory başlatır
  Future<void> startScan();

  ///Inventory durdur
  Future<void> stopScan();

  ///Inventorydeki tagleri flutter tarafına çeker
  Future<void> inventoryAndThenGetTags(WidgetRef ref);

  Future<void> initInventory();

  ///Listeyi temizle
  Future<void> clear();

  ///Buzzer aç
  Future<void> playSound();

  ///Güç ayarını getir
  Future<int> getPower();

  ///Güç ayarını ayarla
  Future<void> setPower(String value);

  ///Read single with tag and update barcode info

  Future<void> singleInventory();

  Future<void> listenAndSetScanToMatchStatus(WidgetRef ref);

  Future<void> scanBarcode(WidgetRef ref,bool isGoToFirstPage);

  Future<void> setStatusOfScanToMatchStatus(ScanToMatchStatus scanToMatchStatus);

  Future<bool> barcodeModeOn(WidgetRef ref);


}
