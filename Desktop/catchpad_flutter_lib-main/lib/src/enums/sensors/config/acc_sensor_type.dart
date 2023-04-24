/// the Accelederometer sensor has 2 modes, gravity
/// and tap. even though it streams on the same characteristic,
/// the shape of data it streams is different.
enum AccSensorType { tap, gravity, force }
