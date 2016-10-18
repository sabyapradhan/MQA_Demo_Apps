
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

public interface GymsScreen1DSServiceRest{

	@GET("/app/57fd125484d1a30300ca2c24/r/gymsScreen1DS")
	void queryGymsScreen1DSItem(
		@Query("skip") String skip,
		@Query("limit") String limit,
		@Query("conditions") String conditions,
		@Query("sort") String sort,
		@Query("select") String select,
		@Query("populate") String populate,
		Callback<List<GymsScreen1DSItem>> cb);

	@GET("/app/57fd125484d1a30300ca2c24/r/gymsScreen1DS/{id}")
	void getGymsScreen1DSItemById(@Path("id") String id, Callback<GymsScreen1DSItem> cb);

	@DELETE("/app/57fd125484d1a30300ca2c24/r/gymsScreen1DS/{id}")
  void deleteGymsScreen1DSItemById(@Path("id") String id, Callback<GymsScreen1DSItem> cb);

  @POST("/app/57fd125484d1a30300ca2c24/r/gymsScreen1DS/deleteByIds")
  void deleteByIds(@Body List<String> ids, Callback<List<GymsScreen1DSItem>> cb);

  @POST("/app/57fd125484d1a30300ca2c24/r/gymsScreen1DS")
  void createGymsScreen1DSItem(@Body GymsScreen1DSItem item, Callback<GymsScreen1DSItem> cb);

  @PUT("/app/57fd125484d1a30300ca2c24/r/gymsScreen1DS/{id}")
  void updateGymsScreen1DSItem(@Path("id") String id, @Body GymsScreen1DSItem item, Callback<GymsScreen1DSItem> cb);

  @GET("/app/57fd125484d1a30300ca2c24/r/gymsScreen1DS")
  void distinct(
        @Query("distinct") String colName,
        @Query("conditions") String conditions,
        Callback<List<String>> cb);
    
    @Multipart
    @POST("/app/57fd125484d1a30300ca2c24/r/gymsScreen1DS")
    void createGymsScreen1DSItem(
        @Part("data") GymsScreen1DSItem item,
        @Part("picture") TypedByteArray picture,
        Callback<GymsScreen1DSItem> cb);
    
    @Multipart
    @PUT("/app/57fd125484d1a30300ca2c24/r/gymsScreen1DS/{id}")
    void updateGymsScreen1DSItem(
        @Path("id") String id,
        @Part("data") GymsScreen1DSItem item,
        @Part("picture") TypedByteArray picture,
        Callback<GymsScreen1DSItem> cb);
}

