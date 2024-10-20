package com.example.blue_sky_station;
import android.content.Context;
import android.graphics.Typeface;
import android.net.wifi.WifiManager;

import androidx.annotation.NonNull;

import com.nexgo.oaf.apiv3.APIProxy;
import com.nexgo.oaf.apiv3.DeviceEngine;
import com.nexgo.oaf.apiv3.DeviceInfo;
import com.nexgo.oaf.apiv3.SdkResult;
import com.nexgo.oaf.apiv3.card.mifare.M1CardHandler;
import com.nexgo.oaf.apiv3.device.beeper.Beeper;
import com.nexgo.oaf.apiv3.device.printer.AlignEnum;
import com.nexgo.oaf.apiv3.device.printer.DotMatrixFontEnum;
import com.nexgo.oaf.apiv3.device.printer.FontEntity;
import com.nexgo.oaf.apiv3.device.printer.GrayLevelEnum;
import com.nexgo.oaf.apiv3.device.printer.OnPrintListener;
import com.nexgo.oaf.apiv3.device.printer.Printer;
import com.nexgo.oaf.apiv3.device.reader.CardInfoEntity;
import com.nexgo.oaf.apiv3.device.reader.CardReader;
import com.nexgo.oaf.apiv3.device.reader.CardSlotTypeEnum;
import com.nexgo.oaf.apiv3.device.reader.OnCardInfoListener;
import com.nexgo.oaf.apiv3.platform.Platform;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    String uid ;
    HashSet<CardSlotTypeEnum> slotTypes = new HashSet<>();
    private final int FONT_SIZE_SMALL = 20;
    private final int FONT_SIZE_NORMAL = 24;
    private FontEntity fontSmall = new FontEntity(DotMatrixFontEnum.CH_SONG_20X20, DotMatrixFontEnum.ASC_SONG_8X16);
    private FontEntity fontNormal = new FontEntity(DotMatrixFontEnum.CH_SONG_24X24, DotMatrixFontEnum.ASC_SONG_12X24);
    private FontEntity fontBold = new FontEntity(DotMatrixFontEnum.CH_SONG_24X24, DotMatrixFontEnum.ASC_SONG_BOLD_16X24);
    private FontEntity fontBig = new FontEntity(DotMatrixFontEnum.CH_SONG_24X24, DotMatrixFontEnum.ASC_SONG_12X24, false, true);
    DeviceEngine deviceEngine;
    Platform platform ;
    boolean isTimeOut;
    Map<Object, Object> dataMap = new HashMap<>();
    private final String READCHANNEL = "samples.flutter.dev/read";
    private final String MainChannel = "samples.flutter.dev/mainInfo";
    private final String PrintChannel = "samples.flutter.dev/print";
    Beeper beeper;
    public DeviceInfo deviceInfo;
    Printer printer ;
    CardReader cardReader;
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        init();
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), PrintChannel)
                .setMethodCallHandler(
                        (call, result) -> {
//                            boolean isEnglish = Boolean.TRUE.equals(call.argument("isEnglish"));
                            if(call.method.equals("print")){
                                String data = call.argument("invoiceTemplate");
                                printInvoice(new PrintCallBack() {
                                    @Override
                                    public void print(int status) {
                                        result.success(status);
                                    }
                                }, data);
                            }

                            else {
                                result.notImplemented();
                            }
                        });
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), READCHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("readCard")) {
                                readCard(new ReadCallback(){
                                    @Override
                                    public void onCreditRead(Map data) {
                                        result.success(data);
                                    }
                                });
                            } else if (call.method.equals("stopRead")) {
                                cardReader.stopSearch();
                                result.success(true);
                            } else {
                                result.notImplemented();
                            }
                        });
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), MainChannel).setMethodCallHandler(
                (call, result) -> {
                    switch (call.method){
                        case "readDeviceInfo":
                            String deviceSn = readDeviceInfo();
                            result.success(deviceSn);
                            break;
                        case "setDateTime":
                            String dateTime = call.arguments();
                            if(dateTime != null)
                            {
                                deviceEngine.setSystemClock(dateTime);
                                result.success(true);
                            } else {
                                result.notImplemented();
                            }
                            break;
                        default:
                            result.notImplemented();
                    }
                });
    }

    public interface PrintCallBack{
        void print(int status);
    }
    //    public void setDefaultSettings(){
//      platform.disableControlBar();
//        platform.enableControlBar();
//        platform.disableHomeButton();
//        platform.disableTaskButton();
//    }
    public String readDeviceInfo() {
        return deviceInfo.getSn();
    }
    public void printInvoice(PrintCallBack printCallBack, String data) {
        try{
            AlignEnum alignEnum = AlignEnum.RIGHT;
            printer.initPrinter();
            printer.appendPrnStr(data, FONT_SIZE_NORMAL, alignEnum, false);
            printer.setGray(GrayLevelEnum.LEVEL_0);
            printer.setTypeface(Typeface.DEFAULT);
            printer.setLetterSpacing(5);
            printer.startPrint(false, new OnPrintListener() {
                @Override
                public void onPrintResult(final int retCode) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            System.out.println("was printed");
                            int status = printer.getStatus();
                            printCallBack.print(status);
                        }
                    });
                }
            });
        }catch (Exception e)
        {
            System.out.println("error in java " + e);
        }
    }
    private void readCard(ReadCallback callback) {
        Thread readThread = new Thread(()-> {

            System.out.println("1");
            cardReader.searchCard(slotTypes, 50, new OnCardInfoListener() {
                @Override
                public void onCardInfo(int retCode, CardInfoEntity cardInfo) {
                    try {
                        System.out.println("2");
                        uid = "";
                        isTimeOut =false;
                        if (retCode == SdkResult.Success) {
                            if (cardInfo != null) {
                                if (cardInfo.getCardExistslot() == CardSlotTypeEnum.RF) {
                                    final M1CardHandler m1CardHandler = deviceEngine.getM1CardHandler();
                                    //step 3 , read UID
                                    uid = m1CardHandler.readUid();
                                    System.out.println("card Id in java " + uid);
                                    dataMap.put("cardId", uid);
                                    dataMap.put("isTimeOut", isTimeOut);
                                    callback.onCreditRead(dataMap);
                                    beeper.beep((short)500, (short)100);
                                }
                            }
                        } else if (retCode == SdkResult.Fail) {
                            System.out.println("ret code was Failed");
                            dataMap.put("cardId", uid);
                            dataMap.put("isTimeOut", isTimeOut);
                            callback.onCreditRead(dataMap);
                        } else {
                            System.out.println("time out ");
                            isTimeOut = true;
                            dataMap.put("cardId", uid);
                            dataMap.put("isTimeOut", isTimeOut);
                            callback.onCreditRead(dataMap);
                        }
                    }catch (Exception e){
                        System.out.println("Exception " + e);
                    }
                }
                @Override
                public void onSwipeIncorrect() {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {}
                    });
                }
                @Override
                public void onMultipleCards() {
                    cardReader.stopSearch();
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {}
                    });
                }
            });

        });
        readThread.start();
    }
    public interface ReadCallback {
        void onCreditRead(Map data);
    }
    public void init() {
        deviceEngine = APIProxy.getDeviceEngine(this);
        platform = deviceEngine.getPlatform();
        deviceInfo = deviceEngine.getDeviceInfo();
        cardReader = deviceEngine.getCardReader();
        slotTypes.add(CardSlotTypeEnum.RF);
        beeper = deviceEngine.getBeeper();
        printer = deviceEngine.getPrinter();

    }

}
