const scanChannelName = 'scan';
const stateChannelName = 'state';

const startScanCommand = 'start';
const startStateListeningCommand = 'start_state_listening';
const startSubscriptionCommand = 'start_subscription';
const touchEventCommand = 'touch_event';
const tapEventCommand = 'tap_event';

const Duration scanDuration = Duration(milliseconds: 5000);
const Duration connectionScanDuration = Duration(milliseconds: 600);
const Duration connectionTimeoutDuration = Duration(milliseconds: 30000);
