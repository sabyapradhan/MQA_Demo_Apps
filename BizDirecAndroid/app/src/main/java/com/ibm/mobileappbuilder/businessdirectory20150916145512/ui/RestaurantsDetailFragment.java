
package com.ibm.mobileappbuilder.businessdirectory20150916145512.ui;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.widget.TextView;
import com.ibm.mobileappbuilder.businessdirectory20150916145512.R;
import ibmmobileappbuilder.actions.ActivityIntentLauncher;
import ibmmobileappbuilder.actions.MapsAction;
import ibmmobileappbuilder.actions.PhoneAction;
import ibmmobileappbuilder.behaviors.ShareBehavior;
import ibmmobileappbuilder.ds.Datasource;
import ibmmobileappbuilder.ds.SearchOptions;
import ibmmobileappbuilder.ds.filter.Filter;
import java.util.Arrays;
import com.ibm.mobileappbuilder.businessdirectory20150916145512.ds.RestaurantsDSItem;
import com.ibm.mobileappbuilder.businessdirectory20150916145512.ds.RestaurantsDS;

public class RestaurantsDetailFragment extends ibmmobileappbuilder.ui.DetailFragment<RestaurantsDSItem> implements ShareBehavior.ShareListener  {

    private Datasource<RestaurantsDSItem> datasource;
    public static RestaurantsDetailFragment newInstance(Bundle args){
        RestaurantsDetailFragment fr = new RestaurantsDetailFragment();
        fr.setArguments(args);

        return fr;
    }

    public RestaurantsDetailFragment(){
        super();
    }

    @Override
    public Datasource<RestaurantsDSItem> getDatasource() {
      if (datasource != null) {
        return datasource;
      }
       datasource = RestaurantsDS.getInstance(new SearchOptions());
        return datasource;
    }

    @Override
    public void onCreate(Bundle state) {
        super.onCreate(state);
        addBehavior(new ShareBehavior(getActivity(), this));

    }

    // Bindings

    @Override
    protected int getLayout() {
        return R.layout.restaurantsdetail_detail;
    }

    @Override
    @SuppressLint("WrongViewCast")
    public void bindView(final RestaurantsDSItem item, View view) {
        if (item.name != null){
            
            TextView view0 = (TextView) view.findViewById(R.id.view0);
            view0.setText(item.name);
            
        }
        if (item.description != null){
            
            TextView view1 = (TextView) view.findViewById(R.id.view1);
            view1.setText(item.description);
            
        }
        if (item.phone != null){
            
            TextView view2 = (TextView) view.findViewById(R.id.view2);
            view2.setText(item.phone);
            bindAction(view2, new PhoneAction(
            new ActivityIntentLauncher()
            , item.phone));
        }
        if (item.address != null){
            
            TextView view3 = (TextView) view.findViewById(R.id.view3);
            view3.setText(item.address);
            bindAction(view3, new MapsAction(
            new ActivityIntentLauncher()
            , "http://maps.google.com/maps?q=" + item.location.toString()));
        }
    }

    @Override
    protected void onShow(RestaurantsDSItem item) {
        // set the title for this fragment
        getActivity().setTitle(null);
    }
    @Override
    public void onShare() {
        RestaurantsDSItem item = getItem();

        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_SEND);
        intent.setType("text/plain");

        intent.putExtra(Intent.EXTRA_TEXT, (item.name != null ? item.name : "" ) + "\n" +
                    (item.description != null ? item.description : "" ) + "\n" +
                    (item.phone != null ? item.phone : "" ) + "\n" +
                    (item.address != null ? item.address : "" ));
        startActivityForResult(Intent.createChooser(intent, getString(R.string.share)), 1);
    }
}

