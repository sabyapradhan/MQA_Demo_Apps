

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
 * "Screen0DS" data source. (e37eb8dc-6eb2-4635-8592-5eb9696050e3)
 */
public class Screen0DS extends AppNowDatasource<Screen0DSItem>{

    // default page size
    private static final int PAGE_SIZE = 20;

    private Screen0DSService service;

    public static Screen0DS getInstance(SearchOptions searchOptions){
        return new Screen0DS(searchOptions);
    }

    private Screen0DS(SearchOptions searchOptions) {
        super(searchOptions);
        this.service = Screen0DSService.getInstance();
    }

    @Override
    public void getItem(String id, final Listener<Screen0DSItem> listener) {
        if ("0".equals(id)) {
                        getItems(new Listener<List<Screen0DSItem>>() {
                @Override
                public void onSuccess(List<Screen0DSItem> items) {
                    if(items != null && items.size() > 0) {
                        listener.onSuccess(items.get(0));
                    } else {
                        listener.onSuccess(new Screen0DSItem());
                    }
                }

                @Override
                public void onFailure(Exception e) {
                    listener.onFailure(e);
                }
            });
        } else {
                      service.getServiceProxy().getScreen0DSItemById(id, new Callback<Screen0DSItem>() {
                @Override
                public void success(Screen0DSItem result, Response response) {
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
    public void getItems(final Listener<List<Screen0DSItem>> listener) {
        getItems(0, listener);
    }

    @Override
    public void getItems(int pagenum, final Listener<List<Screen0DSItem>> listener) {
        String conditions = getConditions(searchOptions, getSearchableFields());
        int skipNum = pagenum * PAGE_SIZE;
        String skip = skipNum == 0 ? null : String.valueOf(skipNum);
        String limit = PAGE_SIZE == 0 ? null: String.valueOf(PAGE_SIZE);
        String sort = getSort(searchOptions);
                service.getServiceProxy().queryScreen0DSItem(
                skip,
                limit,
                conditions,
                sort,
                null,
                null,
                new Callback<List<Screen0DSItem>>() {
            @Override
            public void success(List<Screen0DSItem> result, Response response) {
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
    public void create(Screen0DSItem item, Listener<Screen0DSItem> listener) {
                    
        if(item.pictureUri != null){
            service.getServiceProxy().createScreen0DSItem(item,
                TypedByteArrayUtils.fromUri(item.pictureUri),
                callbackFor(listener));
        }
        else
            service.getServiceProxy().createScreen0DSItem(item, callbackFor(listener));
        
    }

    private Callback<Screen0DSItem> callbackFor(final Listener<Screen0DSItem> listener) {
      return new Callback<Screen0DSItem>() {
          @Override
          public void success(Screen0DSItem item, Response response) {
                            listener.onSuccess(item);
          }

          @Override
          public void failure(RetrofitError error) {
                            listener.onFailure(error);
          }
      };
    }

    @Override
    public void updateItem(Screen0DSItem item, Listener<Screen0DSItem> listener) {
                    
        if(item.pictureUri != null){
            service.getServiceProxy().updateScreen0DSItem(item.getIdentifiableId(),
                item,
                TypedByteArrayUtils.fromUri(item.pictureUri),
                callbackFor(listener));
        }
        else
            service.getServiceProxy().updateScreen0DSItem(item.getIdentifiableId(), item, callbackFor(listener));
        
    }

    @Override
    public void deleteItem(Screen0DSItem item, final Listener<Screen0DSItem> listener) {
                service.getServiceProxy().deleteScreen0DSItemById(item.getIdentifiableId(), new Callback<Screen0DSItem>() {
            @Override
            public void success(Screen0DSItem result, Response response) {
                                listener.onSuccess(result);
            }

            @Override
            public void failure(RetrofitError error) {
                                listener.onFailure(error);
            }
        });
    }

    @Override
    public void deleteItems(List<Screen0DSItem> items, final Listener<Screen0DSItem> listener) {
                service.getServiceProxy().deleteByIds(collectIds(items), new Callback<List<Screen0DSItem>>() {
            @Override
            public void success(List<Screen0DSItem> item, Response response) {
                                listener.onSuccess(null);
            }

            @Override
            public void failure(RetrofitError error) {
                                listener.onFailure(error);
            }
        });
    }

    protected List<String> collectIds(List<Screen0DSItem> items){
        List<String> ids = new ArrayList<>();
        for(Screen0DSItem item: items){
            ids.add(item.getIdentifiableId());
        }
        return ids;
    }

}

