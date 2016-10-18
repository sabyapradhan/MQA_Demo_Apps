
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

public interface LawyersScreen1DSServiceRest{

	@GET("/app/57fd125484d1a30300ca2c24/r/lawyersScreen1DS")
	void queryLawyersScreen1DSItem(
		@Query("skip") String skip,
		@Query("limit") String limit,
		@Query("conditions") String conditions,
		@Query("sort") String sort,
		@Query("select") String select,
		@Query("populate") String populate,
		Callback<List<LawyersScreen1DSItem>> cb);

	@GET("/app/57fd125484d1a30300ca2c24/r/lawyersScreen1DS/{id}")
	void getLawyersScreen1DSItemById(@Path("id") String id, Callback<LawyersScreen1DSItem> cb);

	@DELETE("/app/57fd125484d1a30300ca2c24/r/lawyersScreen1DS/{id}")
  void deleteLawyersScreen1DSItemById(@Path("id") String id, Callback<LawyersScreen1DSItem> cb);

  @POST("/app/57fd125484d1a30300ca2c24/r/lawyersScreen1DS/deleteByIds")
  void deleteByIds(@Body List<String> ids, Callback<List<LawyersScreen1DSItem>> cb);

  @POST("/app/57fd125484d1a30300ca2c24/r/lawyersScreen1DS")
  void createLawyersScreen1DSItem(@Body LawyersScreen1DSItem item, Callback<LawyersScreen1DSItem> cb);

  @PUT("/app/57fd125484d1a30300ca2c24/r/lawyersScreen1DS/{id}")
  void updateLawyersScreen1DSItem(@Path("id") String id, @Body LawyersScreen1DSItem item, Callback<LawyersScreen1DSItem> cb);

  @GET("/app/57fd125484d1a30300ca2c24/r/lawyersScreen1DS")
  void distinct(
        @Query("distinct") String colName,
        @Query("conditions") String conditions,
        Callback<List<String>> cb);
    
    @Multipart
    @POST("/app/57fd125484d1a30300ca2c24/r/lawyersScreen1DS")
    void createLawyersScreen1DSItem(
        @Part("data") LawyersScreen1DSItem item,
        @Part("picture") TypedByteArray picture,
        Callback<LawyersScreen1DSItem> cb);
    
    @Multipart
    @PUT("/app/57fd125484d1a30300ca2c24/r/lawyersScreen1DS/{id}")
    void updateLawyersScreen1DSItem(
        @Path("id") String id,
        @Part("data") LawyersScreen1DSItem item,
        @Part("picture") TypedByteArray picture,
        Callback<LawyersScreen1DSItem> cb);
}

