/**
 * Created on 10/2/24.
 */

public with sharing class API_GetAccount extends Endpoint implements IEndpoint{

    public API_GetAccount(){
       super(new List<String>{'POST','GET'},'application/json');
    }

    public void execute(){
        APIRequest request = (APIRequest) JSON.deserialize(this.bodyString,APIRequest.class);

        //SIMPLE VALIDATION HERE
        if(request.account_id == null){
            throw new ValidationException(400,'Missing account_id param.');
        }

        //QUERY THE ACCOUNTS
        List<Account> accounts = [SELECT Id,Name, Owner.Username FROM Account WHERE Id = :request.account_id];
        if(accounts.isEmpty()){
            throw new ValidationException(500,'No Accounts Found');
        }

        //respond
        APIResponse response = new APIResponse();
        response.data = accounts[0];
        this.respond(200,response);
    }

    public class APIRequest {
        public String account_id;
    }

    public class APIResponse {
        public Account data;
    }

}