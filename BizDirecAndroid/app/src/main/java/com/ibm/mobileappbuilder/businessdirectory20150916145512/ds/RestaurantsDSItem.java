
package com.ibm.mobileappbuilder.businessdirectory20150916145512.ds;
import android.graphics.Bitmap;
import ibmmobileappbuilder.ds.restds.GeoPoint;
import android.net.Uri;

import ibmmobileappbuilder.mvp.model.IdentifiableBean;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.gson.annotations.SerializedName;

public class RestaurantsDSItem implements Parcelable, IdentifiableBean {

    @SerializedName("name") public String name;
    @SerializedName("description") public String description;
    @SerializedName("picture") public String picture;
    @SerializedName("phone") public String phone;
    @SerializedName("location") public GeoPoint location;
    @SerializedName("address") public String address;
    @SerializedName("rating") public String rating;
    @SerializedName("id") public String id;
    @SerializedName("pictureUri") public transient Uri pictureUri;

    @Override
    public String getIdentifiableId() {
      return id;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(name);
        dest.writeString(description);
        dest.writeString(picture);
        dest.writeString(phone);
        dest.writeDoubleArray(location != null  && location.coordinates.length != 0 ? location.coordinates : null);
        dest.writeString(address);
        dest.writeString(rating);
        dest.writeString(id);
    }

    public static final Creator<RestaurantsDSItem> CREATOR = new Creator<RestaurantsDSItem>() {
        @Override
        public RestaurantsDSItem createFromParcel(Parcel in) {
            RestaurantsDSItem item = new RestaurantsDSItem();

            item.name = in.readString();
            item.description = in.readString();
            item.picture = in.readString();
            item.phone = in.readString();
            double[] location_coords = in.createDoubleArray();
            if (location_coords != null)
                item.location = new GeoPoint(location_coords);
            item.address = in.readString();
            item.rating = in.readString();
            item.id = in.readString();
            return item;
        }

        @Override
        public RestaurantsDSItem[] newArray(int size) {
            return new RestaurantsDSItem[size];
        }
    };

}


