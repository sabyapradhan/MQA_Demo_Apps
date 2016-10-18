

package com.ibm.mobileappbuilder.businessdirectory20150916145512.ui;

import android.os.Bundle;

import com.ibm.mobileappbuilder.businessdirectory20150916145512.R;

import java.util.ArrayList;
import java.util.List;

import ibmmobileappbuilder.MenuItem;

import ibmmobileappbuilder.actions.StartActivityAction;
import ibmmobileappbuilder.util.Constants;

/**
 * CategoriesFragment menu fragment.
 */
public class CategoriesFragment extends ibmmobileappbuilder.ui.MenuFragment {

    /**
     * Default constructor
     */
    public CategoriesFragment(){
        super();
    }

    // Factory method
    public static CategoriesFragment newInstance(Bundle args) {
        CategoriesFragment fragment = new CategoriesFragment();

        fragment.setArguments(args);
        return fragment;
    }

    @Override
      public void onCreate(Bundle savedInstanceState) {
          super.onCreate(savedInstanceState);
                }

    // Menu Fragment interface
    @Override
    public List<MenuItem> getMenuItems() {
        ArrayList<MenuItem> items = new ArrayList<MenuItem>();
        items.add(new MenuItem()
            .setLabel("AUTO")
            .setIcon(R.drawable.png_auto951)
            .setAction(new StartActivityAction(CarDealersActivity.class, Constants.DETAIL))
        );
        items.add(new MenuItem()
            .setLabel("GYMS")
            .setIcon(R.drawable.png_gyms477)
            .setAction(new StartActivityAction(HealthClubsActivity.class, Constants.DETAIL))
        );
        items.add(new MenuItem()
            .setLabel("LAWYERS")
            .setIcon(R.drawable.png_lawyers790)
            .setAction(new StartActivityAction(LegalServicesActivity.class, Constants.DETAIL))
        );
        items.add(new MenuItem()
            .setLabel("RESTAURANTS")
            .setIcon(R.drawable.png_restaurants484)
            .setAction(new StartActivityAction(RestaurantsActivity.class, Constants.DETAIL))
        );
        return items;
    }

    @Override
    public int getLayout() {
        return R.layout.fragment_list;
    }

    @Override
    public int getItemLayout() {
        return R.layout.categories_item;
    }
}

