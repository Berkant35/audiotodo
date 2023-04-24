part of 'pad_consts.dart';

// #region sensor config defaults

const ConfigScale defConfigScale = ConfigScale.LIS2DH12_16g;
const ConfigMode defConfigMode = ConfigMode.LIS2DH12_HR_12bit;
const DataRate defDataRate = DataRate.LIS2DH12_ODR_1kHz620_LP;
const ConfigScale defConfigIntScale = ConfigScale.LIS2DH12_2g;
const ConfigMode defConfigIntMode = ConfigMode.LIS2DH12_HR_12bit;
const DataRate defIntDataRate = DataRate.LIS2DH12_ODR_1kHz620_LP;

const bool defSleepEnable = true;

const minDstThreshold = 0;
const maxDstThreshold = 2000;
const defDstThreshold = 60;

const minAccThreshold = 0;
const maxAccThreshold = 127;
const defAccThreshold = 40;

const minAccIntThreshold = 0;
const maxAccIntThreshold = 127;
const defAccIntThreshold = 20;

const minAccIntDuration = 0;
const maxAccIntDuration = 20;
const defAccIntDuration = 5;

const minTimeOut = 0;
const maxTimeOut = 99999;
const defTimeOut = 100;

const int minAccTimeOut = minTimeOut;
const int maxAccTimeOut = maxTimeOut;
const int defAccTimeOut = defTimeOut;

const int minDstTimeOut = minTimeOut;
const int maxDstTimeOut = maxTimeOut;
const int defDstTimeOut = defTimeOut;

const int minAccIntTimeOut = 0;
const int maxAccIntTimeOut = 20;
const int defAccIntTimeOut = 10;
// #endregion

// #region sensor configs defaults
const AccConfigModel defAccConfigModel = AccConfigModel(
  scale: defConfigScale,
  mode: defConfigMode,
  dataRate: defDataRate,
  threshold: defAccThreshold,
  timeout: defAccTimeOut,
);

const AccInterruptConfigModel defAccInterruptConfigModel =
    AccInterruptConfigModel(
  scale: defConfigIntScale,
  mode: defConfigIntMode,
  dataRate: defIntDataRate,
  threshold: defAccIntThreshold,
  duration: defAccIntDuration,
  timeout: defAccIntTimeOut,
  sleepEnable: defSleepEnable,
);

const AccInterruptConfigModel accInterruptConfigModelWithMinusOne =
    AccInterruptConfigModel(
  scale: null,
  mode: null,
  dataRate: null,
  threshold: -1,
  duration: -1,
  timeout: -1,
  sleepEnable: null,
);

const DstConfigModel defDstConfigModel = DstConfigModel(
  threshold: defDstThreshold,
  timeout: defDstTimeOut,
);
// #endregion