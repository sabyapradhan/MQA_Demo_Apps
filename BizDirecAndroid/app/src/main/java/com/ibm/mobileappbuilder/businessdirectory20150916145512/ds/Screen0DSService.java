
package com.ibm.mobileappbuilder.businessdirectory20150916145512.ds;
import java.net.URL;
import com.ibm.mobileappbuilder.businessdirectory20150916145512.R;
import ibmmobileappbuilder.ds.RestService;
import ibmmobileappbuilder.util.StringUtils;

/**
 * "Screen0DSService" REST Service implementation
 */
public class Screen0DSService extends RestService<Screen0DSServiceRest>{

    public static Screen0DSService getInstance(){
          return new Screen0DSService();
    }

    private Screen0DSService() {
        super(Screen0DSServiceRest.class);

    }

    @Override
    public String getServerUrl() {
        return "https://ibm-pods.buildup.io";
    }

    @Override
    protected String getApiKey() {
        return "8QRnDwNp";
    }

    @Override
    public URL getImageUrl(String path){
        return StringUtils.parseUrl("https://ibm-pods.buildup.io/app/57fd125484d1a30300ca2c24",
                path,
                "apikey=8QRnDwNp");
    }

}

