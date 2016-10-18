
package com.ibm.mobileappbuilder.businessdirectory20150916145512.ds;
import java.util.List;
import retrofit.Callback;
import retrofit.http.GET;
import retrofit.http.Query;
import retrofit.http.POST;
import retrofit.http.Body;
import retrofit.http.DELETE;
import retrofit.http.Path;
import retrofit.http.PUT;
import retrofit.mime.TypedByteArray;
import retrofit.http.Part;
import retrofit.http.Multipart;

public interface RestaurantsDSServiceRest{

	@GET("/app/57fd125484d1a30300ca2c24/r/restaurantsDS")
	void queryRestaurantsDSItem(
		@Query("skip") String skip,
		@Query("limit") String limit,
		@Query("conditions") String conditions,
		@Query("sort") String sort,
		@Query("select") String select,
		@Query("populate") String populate,
		Callback<List<RestaurantsDSItem>> cb);

	@GET("/app/57fd125484d1a30300ca2c24/r/restaurantsDS/{id}")
	void getRestaurantsDSItemById(@Path("id") String id, Callback<RestaurantsDSItem> cb);

	@DELETE("/app/57fd125484d1a30300ca2c24/r/restaurantsDS/{id}")
  void deleteRestaurantsDSItemById(@Path("id") String id, Callback<RestaurantsDSItem> cb);

  @POST("/app/57fd125484d1a30300ca2c24/r/restaurantsDS/deleteByIds")
  void deleteByIds(@Body List<String> ids, Callback<List<RestaurantsDSItem>> cb);

  @POST("/app/57fd125484d1a30300ca2c24/r/restaurantsDS")
  void createRestaurantsDSItem(@Body RestaurantsDSItem item, Callback<RestaurantsDSItem> cb);

  @PUT("/app/57fd125484d1a30300ca2c24/r/restaurantsDS/{id}")
  void updateRestaurantsDSItem(@Path("id") String id, @Body RestaurantsDSItem item, Callback<RestaurantsDSItem> cb);

  @GET("/app/57fd125484d1a30300ca2c24/r/restaurantsDS")
  void distinct(
        @Query("distinct") String colName,
        @Query("conditions") String conditions,
        Callback<List<String>> cb);
    
    @Multipart
    @POST("/app/57fd125484d1a30300ca2c24/r/restaurantsDS")
    void createRestaurantsDSItem(
        @Part("data") RestaurantsDSItem item,
        @Part("picture") TypedByteArray picture,
        Callback<RestaurantsDSItem> cb);
    
    @Multipart
    @PUT("/app/57fd125484d1a30300ca2c24/r/restaurantsDS/{id}")
    void updateRestaurantsDSItem(
        @Path("id") String id,
        @Part("data") RestaurantsDSItem item,
        @Part("picture") TypedByteArray picture,
        Callback<RestaurantsDSItem> cb);
}

