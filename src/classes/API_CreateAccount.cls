/**
 * Created on 10/2/24.
 */

public with sharing class API_CreateAccount extends Endpoint implements IEndpoint {

    //ACCEPTS POST REQUEST ONLY
    //RETURNS JSON CONTENT
    public API_CreateAccount(){
        super(new List<String>{'POST'},'application/json');
    }

    //execute
    public void execute(){
        APIRequest request = (APIRequest) JSON.deserialize(this.bodyString,APIRequest.class);
        //PERFORM SOME SIMPLE VALIDATION
        if(request.account_name == null || request.phone_number == null){
            throw new ValidationException(400,'Missing Params');
        }
        //CREATE THE ACCOUNT
        Account account = new Account(Name = request.account_name, Phone = request.phone_number);
        insert account;

        //SEND THE ACCOUNT BACK AS A RESPONSE
        APIResponse response = new APIResponse();
        response.account = account;
        this.respond(200,response);
    }


    public class APIRequest {
        public String account_name;
        public String phone_number;
    }

    public class APIResponse{
        public Account account;
    }

}