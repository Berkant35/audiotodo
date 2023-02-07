package com.uniqueid.i_connect_mobile.rfidreader;

import android.util.Log;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.uniqueid.iconnectMobile.RfidReader.RfidReader;
import com.uniqueid.iconnectMobile.RfidReader.RfidReaderException;
import org.java_websocket.WebSocket;
import org.java_websocket.handshake.ClientHandshake;
import org.java_websocket.server.WebSocketServer;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

public class IconnectServer extends WebSocketServer {

    private static final String TAG = "IconnectServer";
    public IconnectServer(InetSocketAddress address) {
        super(address);
    }

    private WebSocket session;

    public static class SocketRequest {
        public String type;
        public SocketRequestBody body;
    }




    public static class SocketRequestBody {
        public String id;
        private Object param;
    }

    public static class SocketResponse {
        public String type;
        public Object body;
    }

    public HashMap<Integer, RfidReader> readers;

    @Override
    public void onOpen(WebSocket conn, ClientHandshake handshake) {
        this.session = conn;
        this.readers = new HashMap<>();
        Log.i(TAG, "onOpen: session opened???"+conn.getResourceDescriptor());
    }

    @Override
    public void onClose(WebSocket conn, int code, String reason, boolean remote) {

        Log.i(TAG, "onClose: closing session...");
        Log.i(TAG, "onClose: session closed!");

    }

    @Override
    public void onMessage(WebSocket conn, String message) {
        System.out.println(">>>"+message);
        Gson gson = new Gson();

        SocketResponse retval = new SocketResponse();
         /*
         switch (message){
           case "start":
                retval.type = "start";
                retval.body = readers.get(1).startReader().message;
                break;
            case "stop":
                retval.type = "stop";
                retval.body = readers.get(1).stopReader().message;
                break;
            case "read":
                try{
                    String reportMode = App.bridgeSettings.reader.settings.tagReportMode;
                    App.bridgeSettings.reader.settings.tagReportMode = "onstop";
                    retval.type = "read";
                    retval.body = readers.get(1).startReader().message;
                    Thread.sleep(1000);
                    readers.get(1).stopReader();
                    App.bridgeSettings.reader.settings.tagReportMode = "interval";
                } catch (Exception ex){
                    App.bridgeSettings.reader.settings.tagReportMode = "interval";
                    Logger.getLogger(WebSocketServer.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;


        }*/

        /*
        if (retval.type != null){
            System.out.println("Sending: " + gson.toJson(retval));
            this.session.getAsyncRemote().sendText(gson.toJson(retval));
            return;
        }

         */


        SocketRequest request = new SocketRequest();

        try{
            request = gson.fromJson(message, SocketRequest.class);
        } catch (JsonSyntaxException ex){
            System.out.println(">>>>"+ex.getMessage());
            return;
        }

        SocketRequestBody requestBody = new SocketRequestBody();

        try{
            requestBody = gson.fromJson(gson.toJson(request.body), SocketRequestBody.class);
        } catch (JsonSyntaxException ex){
            System.out.println(">>>>"+ex.getMessage());
            return;
        }

        //SocketResponse retval = new SocketResponse();

        retval.type = request.type;
        switch (request.type) {

            case "ping":
                handlePing();
                break;



            //RFID commands

            case "createreader":



                RfidReader.Response rfidReaderResponse = RfidReader.create(gson.toJson(request.body), this.session, this.getClass());

                if(rfidReaderResponse.message.isSuccess){
                    readers.put(rfidReaderResponse.reader.id, rfidReaderResponse.reader);
                }

                retval.body=rfidReaderResponse.message;


                break;


            case "connectreader":

                System.out.println(requestBody.id);
                System.out.println(request.body);
                try {
                    retval.body = Objects.requireNonNull(readers.get(Integer.valueOf(requestBody.id))).connectReader(gson.toJson(request.body.param)).message;
                } catch (RfidReaderException e) {
                    throw new RuntimeException(e);
                }

                // sil
                /*
                String jsonstring = "{\"gpios\":[{\"id\":1,\"mode\"=0},{\"id\":2,\"mode\":0}]}";
                System.out.println(">>>>>>>>>>>>>>>>>>>" + readers.get(Integer.valueOf(requestBody.id)).setGpioModesReader(jsonstring));


                 jsonstring = "{\"gpios\":[{\"id\":1,\"state\":true},{\"id\":2,\"state\":false}]}";
                System.out.println(">>>>>>>>>>>>>>>>>>>" + readers.get(Integer.valueOf(requestBody.id)).setGposReader(jsonstring));
                */



                // sil  json string =
                /*
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
                */

                break;

            case "disconnectreader":

                retval.body = readers.get(Integer.valueOf(requestBody.id)).disconnectReader().message;


                break;

            case "start":
                retval.body = readers.get(1).startReader().message;
                break;
            case "stop":
                retval.body = readers.get(1).stopReader().message;
                break;


            case "startreader":
                retval.body = readers.get(Integer.valueOf(requestBody.id)).startReader().message;
                break;

            case "stopreader":
                retval.body = readers.get(Integer.valueOf(requestBody.id)).stopReader().message;
                break;

            case "writetag":
                System.out.println(requestBody.id);
                System.out.println(request.body);

                RfidReader.WtiteDataParams param = gson.fromJson(gson.toJson(request.body.param), RfidReader.WtiteDataParams.class);

                System.out.println(param.antenna);
                System.out.println(param.filterBank);
                System.out.println(param.filterAddress);
                System.out.println(param.filterLen);
                System.out.println(param.filterEPC);
                System.out.println(param.targetBank);
                System.out.println(param.targetAddress);
                System.out.println(param.targetLen);
                System.out.println(param.targetEPC);




                retval.body = Objects.requireNonNull(readers.get(Integer.valueOf(requestBody.id))).writeDataReader(param.antenna, 1, 32, 96, hexStringToByteArray(param.filterEPC),1,2,6, hexStringToByteArray(param.targetEPC)).message;
                break;

            case "outputonreader":
                System.out.println(requestBody.id);
                System.out.println(request.body);
                try {
                    retval.body = Objects.requireNonNull(readers.get(Integer.valueOf(requestBody.id))).outputOnReader(request.body.param).message;
                } catch (RfidReaderException e) {
                    throw new RuntimeException(e);
                }
                break;
            case "outputoffreader":
                System.out.println(requestBody.id);
                System.out.println(request.body);
                try {
                    retval.body = Objects.requireNonNull(readers.get(Integer.valueOf(requestBody.id))).outputOffReader(request.body.param).message;
                } catch (RfidReaderException e) {
                    throw new RuntimeException(e);
                }
                break;
            // eof RFID commands

        }
        System.out.println("Sending: " + gson.toJson(retval));
        this.session.send  (gson.toJson(retval));

        /*if (data.equals("start")) {
            try {
                readerFeatures = new ImpinjReader();
                System.out.println("Connecting");
                readerFeatures.connect("10.10.255.239");

                Settings settings = readerFeatures.queryDefaultSettings();

                ReportConfig report = settings.getReport();
                report.setIncludeAntennaPortNumber(true);
                report.setMode(ReportMode.Individual);

                // The readerFeatures can be set into various modes in which readerFeatures
                // dynamics are optimized for specific regions and environments.
                // The following mode, AutoSetDenseReader, monitors RF noise and interference and then automatically
                // and continuously optimizes the readerFeatures's configuration
                settings.setReaderMode(ReaderMode.AutoSetDenseReader);

                // set some special settings for antenna 1
                AntennaConfigGroup antennas = settings.getAntennas();
                antennas.disableAll();
                antennas.enableById(new short[]{1});
                antennas.getAntenna((short) 1).setIsMaxRxSensitivity(false);
                antennas.getAntenna((short) 1).setIsMaxTxPower(false);
                antennas.getAntenna((short) 1).setTxPowerinDbm(20.0);
                antennas.getAntenna((short) 1).setRxSensitivityinDbm(-70);

                readerFeatures.setTagReportListener(new TagReportListenerImplementation(this.session));

                System.out.println("Applying Settings");
                readerFeatures.applySettings(settings);

                System.out.println("Starting");
                readerFeatures.start();

            } catch (OctaneSdkException ex) {
                System.out.println(ex.getMessage());
                throw (ex);
            } catch (Exception ex) {
                System.out.println(ex.getMessage());
                ex.printStackTrace(System.out);
                throw (ex);
            }
        } else if (data.equals("stop")) {
            try {
                System.out.println("Stoping");
                readerFeatures.stop();
                readerFeatures.disconnect();
            } catch (OctaneSdkException ex) {
                System.out.println(ex.getMessage());
            } catch (Exception ex) {
                System.out.println(ex.getMessage());
                ex.printStackTrace(System.out);
            }
        } else if (data.equals("ping")) {
            try {
                session.getBasicRemote().sendText("Pong");
            } catch (IOException ex) {
                System.out.println(ex.getMessage());
                ex.printStackTrace(System.out);
            }

        }*/

    }

    @Override
    public void onError(WebSocket conn, Exception ex) {

    }

    @Override
    public void onStart() {
        Log.i(TAG, "onStart: started!");
    }
    public static void onTagReported (WebSocket s, ArrayList<RfidReader.Tag> tags){

        Gson gson = new Gson();

        SocketResponse sr = new SocketResponse();
        sr.type = "tagreport";
        /*for (RfidReader.Tag t : tags){
            try{
                ParseSGTIN psg = ParseSGTIN.Builder().withRFIDTag(t.epc).build();
                t.ean13 = psg.getSGTIN().getCompanyPrefix() + psg.getSGTIN().getItemReference() + psg.getSGTIN().getCheckDigit();
                t.serial = psg.getSGTIN().getSerial();
            } catch (Exception ex){
                System.out.println(ex.getMessage());
                t.ean13 = null;
                t.serial = null;
            }
        } */

        sr.body = tags;

        s.send(gson.toJson(sr));
        System.out.print(" Sending async ");

    }
    void handlePing(){
        Gson gson = new Gson();
        System.out.println("Handling ping");
        SocketResponse response = new SocketResponse();
        response.type = "pong";
        this.session.send(gson.toJson(response));
    }
    public static byte[] hexStringToByteArray(String s) {
        int len = s.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                    + Character.digit(s.charAt(i+1), 16));
        }
        return data;
    }


}
