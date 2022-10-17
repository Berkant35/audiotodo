part of 'native_manager.dart';

enum ChannelKeys { mainChannel, eventChannel }

///Invoke methodların tiplerini topladığımız enum
enum InvokeMethods { init, stopInventory, continueInventory, clearInventory,playSound }

enum BroadCastStates { inventoryAndGetTag }

enum RFIDStatus { connected, disconnected }

abstract class NativeInterface {
  ///Flutter --> JAVA

  ///method channel sadece gidip bir tane veri getirdiğimiz method.
  ///Örnek: connect RFID Device initalize yaptığımız durumu kontrol etmemizi sağlar.
  final MethodChannel _methodChannel =
      MethodChannel(ChannelKeys.mainChannel.name);

  /// event channel javadaki değişiklikleri dinlemememizi sağlayan kısım
  /// Örnek button basılınca eğer bir tag yakalanmadıysa SEARCH State aktif olur.
  final EventChannel _eventChannel =
      EventChannel(ChannelKeys.eventChannel.name);

  ///Initialize RFID...
  Future<RFIDDevice?> connectRFIDDevice();

  Future<void> startScan();

  Future<void> stopScan();

  Future<void> inventoryAndThenGetTags(WidgetRef ref);

  Future<void> clear();

  Future<void> playSound();
}
