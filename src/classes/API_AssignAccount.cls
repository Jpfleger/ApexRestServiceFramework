/**
 * Created on 10/9/24.
 */

public with sharing class API_AssignAccount extends Endpoint implements IEndpoint{


    public API_AssignAccount(){
        super(new List<String>{'POST'},'application/json');
    }

    public void execute() {
        APIRequest request = (APIRequest) JSON.deserialize(this.bodyString,APIRequest.class);

        if(request.account_id == null || request.user_name == null){
            throw new ValidationException(400,'Bad request, missing params');
        }

        List<User> users = [SELECT Id FROM User WHERE Username = :request.user_name];
        if(users.isEmpty()){
            throw new ValidationException(500,'No Matching Users');
        }

        Account account = new Account(Id = request.account_id,OwnerId = users[0].Id);
        update account;

        APIResponse response = new APIResponse();
        response.account = account;
        this.respond(200,response);
    }


    public class APIResponse{
        public Account account;
    }

    public class APIRequest{
        public String account_id;
        public String user_name;
    }
}