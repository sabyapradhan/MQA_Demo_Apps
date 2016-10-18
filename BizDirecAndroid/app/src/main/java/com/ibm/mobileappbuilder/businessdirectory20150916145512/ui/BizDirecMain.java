package com.ibm.mobileappbuilder.businessdirectory20150916145512.ui;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.SparseArray;

import com.ibm.mobileappbuilder.businessdirectory20150916145512.R;
import com.ibm.mqa.MQA;
import com.ibm.mqa.MQA.Mode;
import com.ibm.mqa.config.Configuration;

import ibmmobileappbuilder.ui.DrawerActivity;

public class BizDirecMain extends DrawerActivity {

    public static final String APP_KEY = "1g777e2c010d78be354feaecf368ed6f1a89fedc6bg0g2g450a0e23";

    private final SparseArray<Class<? extends Fragment>> sectionFragments = new SparseArray<>();
    {
                sectionFragments.append(R.id.entry0, CategoriesFragment.class);
    }

    @Override
    public SparseArray<Class<? extends Fragment>> getSectionFragmentClasses() {
      return sectionFragments;
    }

    @Override
    /**
     * onCreate called when main activity is created.
     *
     * Sets up the itemList, application, and sets listeners.
     *
     * @param savedInstanceState
     */
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Configuration configuration = new Configuration.Builder(this)
                .withAPIKey(APP_KEY) //Provides the quality assurance application APP_KEY
                .withMode(Mode.MARKET) //Selects the quality assurance application mode
                .withReportOnShakeEnabled(true) //Enables shake report trigger
                .build();
        MQA.startNewSession(this, configuration);
    }
}

