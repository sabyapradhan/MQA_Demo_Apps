

package com.ibm.mobileappbuilder.businessdirectory20150916145512.ds;

import android.content.Context;

import java.net.URL;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

import ibmmobileappbuilder.ds.SearchOptions;
import ibmmobileappbuilder.ds.restds.AppNowDatasource;
import ibmmobileappbuilder.util.StringUtils;
import ibmmobileappbuilder.ds.restds.TypedByteArrayUtils;

import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

/**
 * "RestaurantsDS" data source. (e37eb8dc-6eb2-4635-8592-5eb9696050e3)
 */
public class RestaurantsDS extends AppNowDatasource<RestaurantsDSItem>{

    // default page size
    private static final int PAGE_SIZE = 20;

    private RestaurantsDSService service;

    public static RestaurantsDS getInstance(SearchOptions searchOptions){
        return new RestaurantsDS(searchOptions);
    }

    private RestaurantsDS(SearchOptions searchOptions) {
        super(searchOptions);
        this.service = RestaurantsDSService.getInstance();
    }

    @Override
    public void getItem(String id, final Listener<RestaurantsDSItem> listener) {
        if ("0".equals(id)) {
                        getItems(new Listener<List<RestaurantsDSItem>>() {
                @Override
                public void onSuccess(List<RestaurantsDSItem> items) {
                    if(items != null && items.size() > 0) {
                        listener.onSuccess(items.get(0));
                    } else {
                        listener.onSuccess(new RestaurantsDSItem());
                    }
                }

                @Override
                public void onFailure(Exception e) {
                    listener.onFailure(e);
                }
            });
        } else {
                      service.getServiceProxy().getRestaurantsDSItemById(id, new Callback<RestaurantsDSItem>() {
                @Override
                public void success(RestaurantsDSItem result, Response response) {
                                        listener.onSuccess(result);
                }

                @Override
                public void failure(RetrofitError error) {
                                        listener.onFailure(error);
                }
            });
        }
    }

    @Override
    public void getItems(final Listener<List<RestaurantsDSItem>> listener) {
        getItems(0, listener);
    }

    @Override
    public void getItems(int pagenum, final Listener<List<RestaurantsDSItem>> listener) {
        String conditions = getConditions(searchOptions, getSearchableFields());
        int skipNum = pagenum * PAGE_SIZE;
        String skip = skipNum == 0 ? null : String.valueOf(skipNum);
        String limit = PAGE_SIZE == 0 ? null: String.valueOf(PAGE_SIZE);
        String sort = getSort(searchOptions);
                service.getServiceProxy().queryRestaurantsDSItem(
                skip,
                limit,
                conditions,
                sort,
                null,
                null,
                new Callback<List<RestaurantsDSItem>>() {
            @Override
            public void success(List<RestaurantsDSItem> result, Response response) {
                                listener.onSuccess(result);
            }

            @Override
            public void failure(RetrofitError error) {
                                listener.onFailure(error);
            }
        });
    }

    private String[] getSearchableFields() {
        return new String[]{"name", "description", "phone", "address", "rating"};
    }

    // Pagination

    @Override
    public int getPageSize(){
        return PAGE_SIZE;
    }

    @Override
    public void getUniqueValuesFor(String searchStr, final Listener<List<String>> listener) {
        String conditions = getConditions(searchOptions, getSearchableFields());
                service.getServiceProxy().distinct(searchStr, conditions, new Callback<List<String>>() {
             @Override
             public void success(List<String> result, Response response) {
                                  result.removeAll(Collections.<String>singleton(null));
                 listener.onSuccess(result);
             }

             @Override
             public void failure(RetrofitError error) {
                                  listener.onFailure(error);
             }
        });
    }

    @Override
    public URL getImageUrl(String path) {
        return service.getImageUrl(path);
    }

    @Override
    public void create(RestaurantsDSItem item, Listener<RestaurantsDSItem> listener) {
                    
        if(item.pictureUri != null){
            service.getServiceProxy().createRestaurantsDSItem(item,
                TypedByteArrayUtils.fromUri(item.pictureUri),
                callbackFor(listener));
        }
        else
            service.getServiceProxy().createRestaurantsDSItem(item, callbackFor(listener));
        
    }

    private Callback<RestaurantsDSItem> callbackFor(final Listener<RestaurantsDSItem> listener) {
      return new Callback<RestaurantsDSItem>() {
          @Override
          public void success(RestaurantsDSItem item, Response response) {
                            listener.onSuccess(item);
          }

          @Override
          public void failure(RetrofitError error) {
                            listener.onFailure(error);
          }
      };
    }

    @Override
    public void updateItem(RestaurantsDSItem item, Listener<RestaurantsDSItem> listener) {
                    
        if(item.pictureUri != null){
            service.getServiceProxy().updateRestaurantsDSItem(item.getIdentifiableId(),
                item,
                TypedByteArrayUtils.fromUri(item.pictureUri),
                callbackFor(listener));
        }
        else
            service.getServiceProxy().updateRestaurantsDSItem(item.getIdentifiableId(), item, callbackFor(listener));
        
    }

    @Override
    public void deleteItem(RestaurantsDSItem item, final Listener<RestaurantsDSItem> listener) {
                service.getServiceProxy().deleteRestaurantsDSItemById(item.getIdentifiableId(), new Callback<RestaurantsDSItem>() {
            @Override
            public void success(RestaurantsDSItem result, Response response) {
                                listener.onSuccess(result);
            }

            @Override
            public void failure(RetrofitError error) {
                                listener.onFailure(error);
            }
        });
    }

    @Override
    public void deleteItems(List<RestaurantsDSItem> items, final Listener<RestaurantsDSItem> listener) {
                service.getServiceProxy().deleteByIds(collectIds(items), new Callback<List<RestaurantsDSItem>>() {
            @Override
            public void success(List<RestaurantsDSItem> item, Response response) {
                                listener.onSuccess(null);
            }

            @Override
            public void failure(RetrofitError error) {
                                listener.onFailure(error);
            }
        });
    }

    protected List<String> collectIds(List<RestaurantsDSItem> items){
        List<String> ids = new ArrayList<>();
        for(RestaurantsDSItem item: items){
            ids.add(item.getIdentifiableId());
        }
        return ids;
    }

}

