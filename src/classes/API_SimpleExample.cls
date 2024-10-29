/**
 * Created on 10/29/24.
 */

public with sharing class API_SimpleExample extends Endpoint implements IEndpoint {

    public API_SimpleExample(){
        super(new List<String>{'GET','POST'},'application/json');
    }
    public void execute() {
        ThisEndpointsResponse response = new ThisEndpointsResponse();
        response.hello = 'World';

        this.respond(200,response);
    }

    public class ThisEndpointsResponse {
        public String hello;
    }

}