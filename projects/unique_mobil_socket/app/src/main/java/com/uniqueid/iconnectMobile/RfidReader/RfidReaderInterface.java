package com.uniqueid.iconnectMobile.RfidReader;

import java.util.ArrayList;

public interface RfidReaderInterface {

    public Boolean connect() throws RfidReaderException;

    public Boolean disconnect() throws RfidReaderException;

    public void populateFeatures() throws RfidReaderException;

    public Boolean start() throws RfidReaderException;

    public Boolean stop() throws RfidReaderException;

    public Boolean writeData (int antenna, int filterBank, int filterAddress, int filterLen, byte[] filterData,
                              int targetBank, int targetAddress, int targetLen, byte[] targetData) throws RfidReaderException;

    public Boolean applySettings() throws RfidReaderException;

    public Boolean setAntennaPower() throws RfidReaderException;



    public ArrayList<RfidReader.BridgeGpioPort> getGpioModes() throws RfidReaderException;

    public Boolean setGpioModes(ArrayList<RfidReader.BridgeGpioPort> ports) throws RfidReaderException;

    public ArrayList<RfidReader.BridgeGpioPort> getGpis() throws RfidReaderException;

    public Boolean setGpos(ArrayList<RfidReader.BridgeGpioPort> gpos) throws RfidReaderException;






}
