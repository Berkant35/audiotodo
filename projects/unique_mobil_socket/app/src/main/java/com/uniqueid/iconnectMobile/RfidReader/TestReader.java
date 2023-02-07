package com.uniqueid.iconnectMobile.RfidReader;



import java.util.*;


public class TestReader extends RfidReader{

    private TagReadListener tagReadListener;
    public TestReader() {

        this.readerType = "TEST";
        this.features = new RfidReaderFeatures();
        this.features.brand = "Unique ID";
        this.settings = new RfidReaderSettings();

        this.tagReadListener = new TestReader.TagReadListener(this);

        //this.isInventoryRunning = false;
    }
    @Override
    public Boolean connect() throws RfidReaderException {
        this.isConnected = true;
        return true;
    }

    @Override
    public Boolean disconnect() throws RfidReaderException {
        this.isConnected = false;
        return true;
    }

    @Override
    public void populateFeatures() throws RfidReaderException {

        this.features.antennaCount = 4;
        this.features.gpiCount = 0;
        this.features.gpoCount = 0;
        this.features.gpioCount = 0;
        this.features.readModes = new ArrayList<>();
        this.features.readModes.add("Default");
        this.features.readPowers = new ArrayList<>();
        this.features.writePowers = new ArrayList<>();
        for (Double i = 1.0; i <= 30.0; i = i + 1.0) {
            this.features.readPowers.add(i);
            this.features.writePowers.add(i);
        }

        this.features.rxSensitivities = new ArrayList<>();

        this.features.rxSensitivities.add(0.0);

        this.features.searchModes = new ArrayList<>();

        this.features.searchModes.add("A");
        this.features.searchModes.add("B");


        this.features.sessions = new ArrayList<>();

        this.features.sessions.add(0);
        this.features.sessions.add(1);
        this.features.sessions.add(2);
        this.features.sessions.add(3);

        this.features.regions = new ArrayList<>();

        this.features.regions.add("Europe");
        this.features.regions.add("China2");
        this.features.regions.add("Korea");
        this.features.regions.add("US");
        this.features.regions.add("User");

    }

    public void startIntervalQuery() {
        TimerTask repeatedTask = new TimerTask() {

            public void run() {
                System.out.println("Task performed on " + new Date());
                tagReadListener.tagRead(null, null, (short) 0, null);
            }
        };
        this.readerTagQueryTimer = new Timer("Timer");

        long delay = this.settings.tagReportInterval;
        long period = this.settings.tagReportInterval;
        this.readerTagQueryTimer.scheduleAtFixedRate(repeatedTask, delay, period);
    }

    public void stopIntervalQuery() {
        this.readerTagQueryTimer.cancel();
    }

    public void startMockGenerator() {
        TimerTask repeatedTask = new TimerTask() {

            public void run() {
                System.out.println("Task performed on " + new Date());
                mocTagGenerator();
            }
        };
        this.readerMockGeneratorTimer = new Timer("Timer");


        this.readerMockGeneratorTimer.scheduleAtFixedRate(repeatedTask,100,100);
    }

    public void stopMockGenerator() {
        this.readerMockGeneratorTimer.cancel();
    }

    private void mocTagGenerator(){
        this.tagReadListener.tagRead("8233", "3038E511C736F900000004D2", (short) 1, -.99);
    }

    public class TagReadListener {

        private final RfidReader bridgeReader;
        private HashMap<String, Tag> reportedTags;

        TagReadListener(RfidReader bridgeReader) {
            this.bridgeReader = bridgeReader;
            this.reportedTags = new HashMap<>();
        }

        public void tagRead(String pc, String epc, short antenna, Double rssi){

            if (epc != null){
                System.out.println("TAG READ" + epc );
                Tag tag = new Tag();

                if (reportedTags.containsKey(epc+"-"+antenna)){
                    tag.readerId = this.bridgeReader.id;
                    tag.epc = epc;
                    tag.rssi = rssi;
                    tag.antennaPort = antenna;
                    tag.seenCount = ++reportedTags.get(epc+"-"+antenna).seenCount;
                    tag.firstSeenTime = reportedTags.get(epc+"-"+antenna).firstSeenTime;
                    tag.lastSeenTime = System.currentTimeMillis();
                } else {
                    tag.readerId = this.bridgeReader.id;
                    tag.epc = epc;
                    tag.antennaPort = antenna;
                    tag.seenCount = 1;
                    tag.firstSeenTime = System.currentTimeMillis();
                    tag.lastSeenTime = System.currentTimeMillis();
                }

                if(bridgeReader.settings.tagReportMode.equals("individual")){//onstop, interval
                    bridgeReader.onTagReported(new ArrayList<> (Arrays.asList(tag)));
                } else{
                    reportedTags.put(tag.epc+"-"+tag.antennaPort, tag);

                }
            } else {
                System.out.println("TAG REPORT");
                bridgeReader.onTagReported( new ArrayList<> (reportedTags.values()));
                reportedTags.clear();
            }



        }
    }

    @Override
    public Boolean start() throws RfidReaderException {

        switch (this.settings.tagReportMode){
            case "individual":
                break;
            case "onstop":
                break;
            case "interval":
                startIntervalQuery();
                break;

        }

        this.isActive = true;
        startMockGenerator();
        return true;
    }

    @Override
    public Boolean stop() throws RfidReaderException {

        switch (this.settings.tagReportMode) {
            case "individual":
                break;
            case "onstop":
                tagReadListener.tagRead( null, null, (short) 0, null);
                break;
            case "interval":
                stopIntervalQuery();
                tagReadListener.tagRead(null, null, (short) 0, null);
                break;
        }

        this.isActive = false;
        stopMockGenerator();
        return true;
    }

    @Override
    public Boolean writeData(int antenna, int filterBank, int filterAddress, int filterLen, byte[] filterData, int targetBank, int targetAddress, int targetLen, byte[] targetData) throws RfidReaderException {
        return null;
    }

    @Override
    public Boolean applySettings() throws RfidReaderException {
        return null;
    }

    @Override
    public Boolean setAntennaPower() throws RfidReaderException {
        return null;
    }

    @Override
    public ArrayList<BridgeGpioPort> getGpioModes() throws RfidReaderException {
        return null;
    }

    @Override
    public Boolean setGpioModes(ArrayList<BridgeGpioPort> ports) throws RfidReaderException {
        return null;
    }

    @Override
    public ArrayList<BridgeGpioPort> getGpis() throws RfidReaderException {
        return null;
    }

    @Override
    public Boolean setGpos(ArrayList<BridgeGpioPort> gpos) throws RfidReaderException {
        return null;
    }
}

