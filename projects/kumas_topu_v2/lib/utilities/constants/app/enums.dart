enum LoadingStates {loading,loaded}

enum OperationStatus { IDLE, INVENTORYLIST, INVENTORY, ADDITEM, SETTINGS,SCANTOMATCH }

enum TriggerModeStatus {IDLE,BARCODE,RFID}

enum ScanToMatchStatus {IDLE,
  SCANNING,
  WAIT_TO_EPC,
  RUNNING_INVENTORY,
  STOPPING_INVENTORY}

enum TriggerPressStatus {PRESSING,
  STOPPED,
  IDLE;}
