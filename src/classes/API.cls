/**
 * Created on 10/2/24.
 */
@RestResource(UrlMapping='/api/v1/*')
global class API {

    /**
     * endpointMap
     * Dynamically map your endpoints to the correct classes.
     */
    private static Map<String,Type> endpointMap = new Map<String,Type>{
            '/api/v1/simpleexample'    =>  API_SimpleExample.class
    };


    @HttpGet
    global static void getRequest(){
        try{
            executeRequest();
        }catch(Endpoint.ValidationException validationException){
            //THOW OUR FAIL RESPONSE
            Endpoint.failResponse(validationException.statusCode,validationException.getMessage());
        }
    }

    @HttpPost
    global static void postRequest() {
        try{
            executeRequest();
        }catch(Endpoint.ValidationException validationException){
            //THOW OUR FAIL RESPONSE
            Endpoint.failResponse(validationException.statusCode,validationException.getMessage());
        }
    }

    /**
     * Static function to execute the API class's "execute" method.
     */
    private static void executeRequest(){
        //CHECK IF ENDPOINT IS REGISTERED.
        String uri = Restcontext.request.requestURI.toLowerCase();
        if(! endpointMap.containsKey(uri)) {
            throw new Endpoint.ValidationException(404,'Unknown Endpoint: '+RestContext.request.requestURI);
        }

        //EXECUTE THE ENDPOINT
        Endpoint.IEndpoint endpointClass = (Endpoint.IEndpoint) endpointMap.get(uri).newInstance();
        endpointClass.execute();
    }
}