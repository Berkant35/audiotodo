package com.uniqueid.iconnectMobile.RfidReader;

import com.google.gson.Gson;
import com.uniqueid.i_connect_mobile.rfidreader.IconnectServer;
import org.java_websocket.WebSocket;


import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Timer;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Korkut
 */
public abstract class RfidReader implements RfidReaderInterface {


    public Integer id;
    public String readerType;
    public ConnectionType connectionType;
    public String address;
    public Integer port;
    public Boolean isConnected;
    public Boolean isActive;
    public WebSocket session;
    public Class server;
    public RfidReaderFeatures features;
    public RfidReaderSettings settings;
    public Long readerTimeDiff;
    public Timer readerTagQueryTimer;
    public Timer readerMockGeneratorTimer;
    public Timer readerInventoryTimer;
    //public TagReportMode readerTagReportMode;

    RfidReader(){
    }





    public static class RequestMessage{
        public Integer id;
        public Object param;
    }

    public static class ParamCreateReader{
        public Integer id;
        public String readerType;
        public String connectionType;
        public String address;
    }

    public static class ParamConnectReader{
        public Integer id;
        public RfidReaderSettings settings;
    }


    public static class Response{
        public ResponseMessage message;
        public RfidReader reader;
        public Tag tag;
    }
    public static class ResponseMessage{
        public Integer id;
        public Boolean isSuccess;
        public String message;
        public RfidReaderFeatures readerFeatures;
    }

    /*public enum GpioMode {
        OUTPUT (0),
        INPUT (1);

        private final int value;

        private GpioMode(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }
    }*/



    public class Tag {
        public Integer readerId;
        public String epc;
        public String tid;
        public String pcBits;
        public Short antennaPort;
        public Double rssi;
        public Long firstSeenTime;
        public Long lastSeenTime;
        public Short seenCount;
        public String ean13;
        public String serial;

    }

    /*
    public static class BridgeGpiPort {
        public Integer id;
        public Boolean state;
    }

    public static class BridgeGpoPort {
        public Integer id;
        public Boolean state;
    }
    */


    public static class BridgeGpioPort {
        public Integer id;
        public Boolean state;
        public Integer mode;
    }

    /*public enum TagReportMode{
        INDIVIDUAL ("individual"),
        ONQUERY ("onQuery"),
        ONSTOP ("onStop");

        private final String name;

        private TagReportMode(String name) {
            this.name = name;
        }

        @Override
        public String toString() {
            return name;
        }
    }*/

    public enum ConnectionType{
        SERIAL ("Serial"),
        NETWORK ("Network"),
        BLUETOOTH ("Bluetooth");

        private final String name;

        private ConnectionType(String name) {
            this.name = name;
        }

        @Override
        public String toString(){
            return name;
        }


    }



    public enum Baudrate{
        Baud_None(0),
        Baud_9600 (9600),
        Baud_19200 (19200);

        private final Integer value;
        private Baudrate (Integer value) {
            this.value = value;
        }
        public Integer getValue() {
            return value;
        }

    }



    public static Response create(String requestObject, WebSocket session, Class serverClass ){
        Gson gson = new Gson();
        RfidReader.RequestMessage requestMessage = gson.fromJson(requestObject,RequestMessage.class);

        ParamCreateReader param = gson.fromJson(gson.toJson(requestMessage.param), ParamCreateReader.class);

        Response response = new Response();
        ResponseMessage responseMessage = new ResponseMessage();

        try {
            RfidReaderFactory rf = new RfidReaderFactory();
            RfidReader reader = rf.getRfidReader(param.readerType);
            reader.id = param.id;
            reader.address = param.address;
            reader.isConnected = false;
            reader.isActive = false;
            reader.session = session;
            reader.server = serverClass;
            responseMessage.id = reader.id;
            responseMessage.isSuccess = true;
            responseMessage.message = "Reader created succesfully.";
            response.reader = reader;

        } catch (RfidReaderException ex) {
            responseMessage.id = param.id;
            responseMessage.isSuccess = false;
            responseMessage.message = ex.getMessage();
            //System.out.println(ex.getMessage());
        } catch (Exception ex) {
            responseMessage.id = param.id;
            responseMessage.isSuccess = false;
            responseMessage.message = ex.getMessage();
            System.out.println(ex.getMessage());
            ex.printStackTrace(System.out);
        }

        response.message =responseMessage;
        return response;
    }

    public Response connectReader(String settingsJsonStr) throws RfidReaderException{
        Gson gson = new Gson();

        this.settings = gson.fromJson(settingsJsonStr, RfidReaderSettings.class);

        Response response = new Response();

        ResponseMessage responseMessage = new ResponseMessage();
        responseMessage.id = this.id;

        if (!this.isConnected){
            try {
                this.connect();
                if (this.features.model == null){
                    populateFeatures();
                    ArrayList<BridgeGpioPort> gpiosToSetOutput = new ArrayList<>();
                    if (this.features.gpioCount > 0) {
                        for (BridgeGpioPort gpioPort : this.getGpioModes()) {
                            gpioPort.mode = 0;
                            gpiosToSetOutput.add(gpioPort);
                        }
                    }

                    if (gpiosToSetOutput.size() > 0){
                        this.setGpioModes(gpiosToSetOutput);
                    }
                }
                responseMessage.isSuccess = true;
                responseMessage.message = "Reader connected succesfully.";
                responseMessage.readerFeatures = this.features;
            } catch (RfidReaderException ex) {

                responseMessage.isSuccess = false;
                responseMessage.message = ex.getMessage();
                //System.out.println(ex.getMessage());
                this.disconnect();
            } catch (Exception ex) {
                responseMessage.isSuccess = false;
                responseMessage.message = ex.getMessage();
                System.out.println(ex.getMessage());
                ex.printStackTrace(System.out);
                this.disconnect();
            }
        } else {
            responseMessage.isSuccess = false;
            responseMessage.message = "Reader already connected.";
        }


        response.message =responseMessage;
        return response;
    }



    public Response disconnectReader(){
        Gson gson = new Gson();


        Response response = new Response();

        ResponseMessage responseMessage = new ResponseMessage();
        responseMessage.id = this.id;

        if (this.isConnected){
            try {

                ArrayList<BridgeGpioPort> gpiosToSwitchOff = new ArrayList<>();
                if (this.features.gpioCount > 0) {
                    for (BridgeGpioPort gpioPort : this.getGpioModes()) {
                        if (gpioPort.mode == 0) {
                            gpioPort.state = false;
                            gpiosToSwitchOff.add(gpioPort);
                        }
                    }
                } else if (this.features.gpoCount > 0) {
                    for (Integer i = 1; i <= this.features.gpoCount; i++) {
                        BridgeGpioPort gpioPort = new BridgeGpioPort();
                        gpioPort.id = i;
                        gpioPort.state = false;
                        gpiosToSwitchOff.add(gpioPort);
                    }
                }

                if (gpiosToSwitchOff.size() > 0) {
                    this.setGpos(gpiosToSwitchOff);
                }

                this.disconnect();
                responseMessage.isSuccess = true;
                responseMessage.message = "Reader disconnected succesfully.";
            } catch (RfidReaderException ex) {

                responseMessage.isSuccess = false;
                responseMessage.message = ex.getMessage();
                //System.out.println(ex.getMessage());
            } catch (Exception ex) {
                responseMessage.isSuccess = false;
                responseMessage.message = ex.getMessage();
                System.out.println(ex.getMessage());
                ex.printStackTrace(System.out);
            }
        } else {
            responseMessage.isSuccess = false;
            responseMessage.message = "Reader already disconnected.";
        }


        response.message =responseMessage;
        return response;
    }

    public Response writeDataReader(int antenna, int filterBank, int filterAddress, int filterLen, byte[] filterData,
                                    int targetBank, int targetAddress, int targetLen, byte[] targetData){

        Gson gson = new Gson();


        Response response = new Response();

        ResponseMessage responseMessage = new ResponseMessage();
        responseMessage.id = this.id;




        if (this.isConnected) {
            try {
                this.writeData( antenna,  filterBank,  filterAddress,  filterLen,  filterData,
                        targetBank,  targetAddress,  targetLen, targetData);
                responseMessage.isSuccess = true;
                responseMessage.message = "Write tag succesfully.";
            } catch (RfidReaderException ex) {

                responseMessage.isSuccess = false;
                responseMessage.message = ex.getMessage();
                System.out.println("280"+ex.getMessage());
            } catch (Exception ex) {
                responseMessage.isSuccess = false;
                responseMessage.message = ex.getMessage();
                System.out.println("284"+ex.getMessage());
                ex.printStackTrace(System.out);
            }
        } else {
            responseMessage.isSuccess = false;
            responseMessage.message = "Cannot write tag. Reader not connected.";
        }

        response.message = responseMessage;
        return response;

    }

    public Response startReader() {
        Gson gson = new Gson();


        Response response = new Response();

        ResponseMessage responseMessage = new ResponseMessage();
        responseMessage.id = this.id;

        if (this.isConnected) {
            try {
                this.start();
                responseMessage.isSuccess = true;
                responseMessage.message = "Reader started succesfully.";
            } catch (RfidReaderException ex) {

                responseMessage.isSuccess = false;
                responseMessage.message = ex.getMessage();
                System.out.println("280"+ex.getMessage());
            } catch (Exception ex) {
                responseMessage.isSuccess = false;
                responseMessage.message = ex.getMessage();
                System.out.println("284"+ex.getMessage());
                ex.printStackTrace(System.out);
            }
        } else {
            responseMessage.isSuccess = false;
            responseMessage.message = "Cannot start reader. Reader not connected.";
        }

        response.message = responseMessage;
        return response;
    }

    public Response outputOnReader(Object param) throws RfidReaderException{

        Gson gson = new Gson();

        System.out.println("outputOnGpio()" + param);
        Response response = new Response();
        ResponseMessage responseMessage = new ResponseMessage();
        responseMessage.id = this.id;

        ArrayList<BridgeGpioPort> gpios = new ArrayList<>();


        try {
            if (param instanceof java.util.ArrayList) {
                System.out.println("its an array");

                for (Object o : ((ArrayList<?>) param)) {
                    BridgeGpioPort gpio = new BridgeGpioPort();
                    gpio.id = ((Double) (o)).intValue();
                    gpio.state = true;
                    gpios.add(gpio);
                }

            } else if (param instanceof Double) {
                System.out.println("its an Double");
                BridgeGpioPort gpio = new BridgeGpioPort();
                gpio.id = ((Double) (param)).intValue();
                gpio.state = true;
                gpios.add(gpio);
            } else {
                throw new RfidReaderException("Invalid Parameter!");
            }

            this.setGposReader(gpios);

            responseMessage.isSuccess = true;
            responseMessage.message = "Reader GPIO output on successful!.";

        } catch (RfidReaderException ex) {
            responseMessage.isSuccess = false;
            responseMessage.message = ex.getMessage();
            System.out.println(ex.getMessage());
            ex.printStackTrace(System.out);
        } catch (Exception ex) {
            responseMessage.isSuccess = false;
            responseMessage.message = ex.getMessage();
            System.out.println(ex.getMessage());
            ex.printStackTrace(System.out);
        }



        response.message = responseMessage;
        return response;
    }

    public Response outputOffReader(Object param) throws RfidReaderException{

        Gson gson = new Gson();

        System.out.println("outputOnGpio()" + param);
        Response response = new Response();

        ResponseMessage responseMessage = new ResponseMessage();
        responseMessage.id = this.id;

        ArrayList<BridgeGpioPort> gpios = new ArrayList<>();


        try {
            if (param instanceof java.util.ArrayList) {
                System.out.println("its an array");

                for (Object o : ((ArrayList<?>) param)) {
                    BridgeGpioPort gpio = new BridgeGpioPort();
                    gpio.id = ((Double) (o)).intValue();
                    gpio.state = false;
                    gpios.add(gpio);
                }

            } else if (param instanceof Double) {
                System.out.println("its an Double");
                BridgeGpioPort gpio = new BridgeGpioPort();
                gpio.id = ((Double) (param)).intValue();
                gpio.state = false;
                gpios.add(gpio);
            } else {
                throw new RfidReaderException("Invalid Parameter!");
            }

            this.setGposReader(gpios);

            responseMessage.isSuccess = true;
            responseMessage.message = "Reader GPIO output off successful!.";


        } catch (RfidReaderException ex) {
            responseMessage.isSuccess = false;
            responseMessage.message = ex.getMessage();
            System.out.println(ex.getMessage());
            ex.printStackTrace(System.out);
        } catch (Exception ex) {
            responseMessage.isSuccess = false;
            responseMessage.message = ex.getMessage();
            System.out.println(ex.getMessage());
            ex.printStackTrace(System.out);
        }



        response.message = responseMessage;
        return response;
    }

    public Response setGposReader(ArrayList<BridgeGpioPort> gpios) throws RfidReaderException{


        Response response = new Response();

        ResponseMessage responseMessage = new ResponseMessage();
        responseMessage.id = this.id;
        if (this.isConnected) {
            try{
                if (this.features.gpioCount < 0 && this.features.gpoCount < 1 ) {
                    throw new RfidReaderException("Reader does not support GPIO or GPO!");

                }



                if (this.features.gpioCount > 1) {
                    HashSet<Integer> programmedGpos = new HashSet<>();
                    for (BridgeGpioPort mode : this.getGpioModes()) {
                        if (mode.mode == 0) {
                            programmedGpos.add(mode.id);
                        }
                    }
                    for (BridgeGpioPort outPort : gpios) {
                        if (!programmedGpos.contains(outPort.id)) {
                            throw new RfidReaderException("GPIO port " + outPort.id + " is not exist or not set as output!");
                        }
                    }
                } else {
                    for (BridgeGpioPort outPort : gpios) {
                        if (outPort.id < 1 || outPort.id > this.features.gpoCount) {
                            throw new RfidReaderException("GPIO port " + outPort.id + " is not exist!");
                        }
                    }
                }



                this.setGpos(gpios );

                responseMessage.isSuccess = true;
                responseMessage.message = "Reader GPOs set succesfully.";


            } catch (Exception ex) {
                responseMessage.isSuccess = false;
                responseMessage.message = ex.getMessage();
                System.out.println(ex.getMessage());
                ex.printStackTrace(System.out);

                throw new RfidReaderException(ex.getMessage());
            }

        } else {
            throw new RfidReaderException("Cannot set GPIO. Reader not connected.");

        }



        return response;
    }


    public Response setGpioModesReader(String params) throws RfidReaderException{
        Gson gson = new Gson();



        Response response = new Response();

        ResponseMessage responseMessage = new ResponseMessage();
        responseMessage.id = this.id;
        if (this.isConnected) {
            try{
                if (this.features.gpioCount < 1) {
                    throw new RfidReaderException("Reader does not support programmable GPIO");
                }

                GpioParams param = gson.fromJson(params, GpioParams.class);

                this.setGpioModes( param.gpios );

                responseMessage.isSuccess = true;
                responseMessage.message = "Reader GPIOs configured succesfully.";


            } catch (Exception ex) {
                responseMessage.isSuccess = false;
                responseMessage.message = ex.getMessage();
                System.out.println(ex.getMessage());
                ex.printStackTrace(System.out);
            }

        } else {
            responseMessage.isSuccess = false;
            responseMessage.message = "Cannot set GPIO mode. Reader not connected.";
        }



        return response;
    }


    public Response stopReader() {
        Gson gson = new Gson();

        Response response = new Response();

        ResponseMessage responseMessage = new ResponseMessage();
        responseMessage.id = this.id;

        if (this.isConnected) {
            if (this.isActive){
                try {
                    this.stop();
                    responseMessage.isSuccess = true;
                    responseMessage.message = "Reader stopped succesfully.";
                } catch (RfidReaderException ex) {

                    responseMessage.isSuccess = false;
                    responseMessage.message = ex.getMessage();
                    //System.out.println(ex.getMessage());
                } catch (Exception ex) {
                    responseMessage.isSuccess = false;
                    responseMessage.message = ex.getMessage();
                    System.out.println(ex.getMessage());
                    ex.printStackTrace(System.out);
                }
            } else {
                responseMessage.isSuccess = false;
                responseMessage.message = "Cannot stop reader. Reader already stopped.";
            }

        } else {
            responseMessage.isSuccess = false;
            responseMessage.message = "Cannot stop reader. Reader not connected.";
        }

        response.message = responseMessage;
        return response;
    }


    public void onTagReported (List<Tag> tags){

        if (tags.size()>0){
            try {
                this.server
                        .getMethod("onTagReported", WebSocket.class, ArrayList.class)
                        .invoke(null, this.session, tags);
            } catch (NoSuchMethodException | SecurityException | IllegalAccessException | IllegalArgumentException | InvocationTargetException ex) {
                Logger.getLogger(RfidReader.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

    }




    public class GpioParams{
        public ArrayList<BridgeGpioPort> gpios;
    }

    public class WtiteDataParams{
        public int antenna;
        public int filterBank;
        public int filterAddress;
        public int filterLen;
        public String filterEPC;
        public int targetBank;
        public int targetAddress;
        public int targetLen;
        public String targetEPC;
    }


}

/*

// sil

        BridgeGpioPort gp1 = new BridgeGpioPort();
        gp1.id = 1;
        gp1.mode = GpioMode.OUTPUT;

        BridgeGpioPort gp2 = new BridgeGpioPort();
        gp2.id = 2;
        gp2.mode = GpioMode.OUTPUT;

        this.setGpioModes(new ArrayList<>(Arrays.asList(gp1, gp2)));


        System.out.println("gpis>>>>>>><<<<");
        for (RfidReader.BridgeGpioPort gpi : this.getGpis()) {
            System.out.println("gpis>>>>>()" + gpi.id + ">>" + gpi.state);
        }

        System.out.println("gpo>>>>");

        BridgeGpioPort gpo1 = new BridgeGpioPort();
        gpo1.id = 1;
        gpo1.state = true;

        BridgeGpioPort gpo2 = new BridgeGpioPort();
        gpo2.id = 2;
        gpo2.state = true;

        this.setGpos(new ArrayList<>(Arrays.asList(gpo1, gpo2)));

        ArrayList<BridgeGpioPort> modes = this.getGpioModes();

        System.out.println("modes>>>>>" + modes);

        for (BridgeGpioPort mode :modes){
           System.out.println("mode.id>>>>>" + mode.id);
           System.out.println("mode.mode>>>>>" + mode.mode);
        }


        // end of sill
*/

