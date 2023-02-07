package com.uniqueid.iconnectMobile.RfidReader;

import java.util.List;

public class RfidReaderSettings {
    public String settingsStr;
    public String readerMode;
    public String searchMode;
    public Integer session;
    public Integer tagPopulation;
    public List<Antenna> antennas;
    public String tagReportMode;
    public Long tagReportInterval;
    public Double commonWritePower;
    public Double commonReadPower;
    public Boolean useCommonPowerSettings;
    public Integer inventoryOnTime;
    public Integer inventoryOffTime;
    public String region;

    public class Antenna {
        public Integer portNumber;
        public Boolean isActive;
        public Double writePower;
        public Double readPower;
    }
}
