
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

public interface Screen0DSServiceRest{

	@GET("/app/57fd125484d1a30300ca2c24/r/screen0DS")
	void queryScreen0DSItem(
		@Query("skip") String skip,
		@Query("limit") String limit,
		@Query("conditions") String conditions,
		@Query("sort") String sort,
		@Query("select") String select,
		@Query("populate") String populate,
		Callback<List<Screen0DSItem>> cb);

	@GET("/app/57fd125484d1a30300ca2c24/r/screen0DS/{id}")
	void getScreen0DSItemById(@Path("id") String id, Callback<Screen0DSItem> cb);

	@DELETE("/app/57fd125484d1a30300ca2c24/r/screen0DS/{id}")
  void deleteScreen0DSItemById(@Path("id") String id, Callback<Screen0DSItem> cb);

  @POST("/app/57fd125484d1a30300ca2c24/r/screen0DS/deleteByIds")
  void deleteByIds(@Body List<String> ids, Callback<List<Screen0DSItem>> cb);

  @POST("/app/57fd125484d1a30300ca2c24/r/screen0DS")
  void createScreen0DSItem(@Body Screen0DSItem item, Callback<Screen0DSItem> cb);

  @PUT("/app/57fd125484d1a30300ca2c24/r/screen0DS/{id}")
  void updateScreen0DSItem(@Path("id") String id, @Body Screen0DSItem item, Callback<Screen0DSItem> cb);

  @GET("/app/57fd125484d1a30300ca2c24/r/screen0DS")
  void distinct(
        @Query("distinct") String colName,
        @Query("conditions") String conditions,
        Callback<List<String>> cb);
    
    @Multipart
    @POST("/app/57fd125484d1a30300ca2c24/r/screen0DS")
    void createScreen0DSItem(
        @Part("data") Screen0DSItem item,
        @Part("picture") TypedByteArray picture,
        Callback<Screen0DSItem> cb);
    
    @Multipart
    @PUT("/app/57fd125484d1a30300ca2c24/r/screen0DS/{id}")
    void updateScreen0DSItem(
        @Path("id") String id,
        @Part("data") Screen0DSItem item,
        @Part("picture") TypedByteArray picture,
        Callback<Screen0DSItem> cb);
}

