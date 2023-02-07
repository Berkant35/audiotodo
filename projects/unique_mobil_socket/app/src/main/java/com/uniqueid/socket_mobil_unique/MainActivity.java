package com.uniqueid.socket_mobil_unique;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import com.uniqueid.i_connect_mobile.rfidreader.IconnectServer;
import org.java_websocket.WebSocket;

import java.net.InetSocketAddress;

public class MainActivity extends AppCompatActivity {
    private static final String TAG = "MainActivity";
    InetSocketAddress inetSockAddress = new InetSocketAddress("0.0.0.0", 8025);
    IconnectServer iconnectServer;
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        iconnectServer = new IconnectServer(inetSockAddress);
        iconnectServer.setReuseAddr(true);
        iconnectServer.start();
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        try {
            iconnectServer.stop(100,"bye bye!");
            Log.i(TAG, "onDestroy: STOPPED!");
        } catch (InterruptedException e) {
            Log.e(TAG, "onDestroy: FAILED TO STOP!");
            throw new RuntimeException(e);
        }
    }

}