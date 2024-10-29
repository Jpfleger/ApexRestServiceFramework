/**
 * Created on 10/9/24.
 */

public virtual class Endpoint {

    protected String bodyString;
    protected String paramString;
    protected ResponseWrapper responseWrapper;

    /**
     * Validation Exception
     * takes an integer and an error message, please throw this anywhere you want to
     * to kill the execution of code in your endpoint class
     */
    public class ValidationException extends Exception{
        public Integer statusCode;

        public ValidationException(Integer statusCode,String error_message){
            this.statusCode = statusCode;
            this.setMessage(error_message);
        }
    }

    /**
     * Implement this for any new endpoint in salesforce.
     */
    public interface IEndpoint {
        void execute();
    }

    public Endpoint(List<String> allowableMethods, String returnContentType) {
        /***
         * get Body
        */
        if(RestContext.request.requestBody != null){
            this.bodyString = RestContext.request.requestBody.toString();
        }

        /***
         * get parameters from get request
        */
        if(RestContext.request.params != null){
            this.paramString = JSON.serialize(RestContext.request.params);
        }

        /***
         * check if param is allowable
        */
        if(! allowableMethods.contains(RestContext.request.httpMethod) ){
            //THROW SOME TYPE OF ERROR HERE
            throw new ValidationException(400,'Method: '+RestContext.request.httpMethod+' Not Allowed For Endpoint: '+RestContext.request.requestURI);
        }

        //SET RESPONSE CONTENT TYPE
        RestContext.response.headers.put('Content-Type',returnContentType);

        //BUILD RESPONSE CLASS
        this.responseWrapper = new ResponseWrapper();
    }

    /**
     * @param statusCode Integer
     * @param responseBody Object
     * @description takes a response object, turns it into json and then sends it back to the
     * api call with the status code
     */
    protected void respond(Integer statusCode,Object responseBody) {

        this.responseWrapper.success = (statusCode == 200 || statusCode == 201);
        this.responseWrapper.data = responseBody;

        String responseBodyString = JSON.serialize(this.responseWrapper,true);

        RestContext.response.statusCode = statusCode;
        RestContext.response.responseBody = Blob.valueOf(responseBodyString);
    }

    /**
     * @param statusCode  Integer
     * @param error_message String
     * @description  static version of the response method, specifically designed to throw failures in the
     * event that an endpoint class can not be instantiated.
     */
    public static void failResponse(Integer statusCode,String error_message) {
        ResponseWrapper responseWrapper = new ResponseWrapper();
        responseWrapper.success = false;
        responseWrapper.error_message = error_message;

        String responseBodyString = JSON.serialize(responseWrapper,true);
        RestContext.response.headers.put('Content-Type','application/json');
        RestContext.response.statusCode = statusCode;
        RestContext.response.responseBody = Blob.valueOf(responseBodyString);
    }

    /****
     * simple response wrapper
     */
    public class ResponseWrapper{
        public Boolean success;
        public String error_message;
        public Object data;
    }

}