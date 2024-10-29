# Simple APEX API FRAMEWORK

A simple and straight forward framework that allows for multiple endpoints and dynamic routing. 

To create a new endpoint. Simply create a new class that extends <code>Endpoint</code> and implements <code>IEndpoint</code>

This new class will need to have an execute method that will run when the endpoint is hit, and a constructor that calls a super method. 

The super method will have two params:

<b>allowableMethods</b>, this is a List<String> that holds the allowed method used when connecting with the endpoint.
<p><b>returnType</b> the content-type for the return response</p>

<code>Super(new List<String>{'GET','POST'}, 'application/json');</code>

Finally, to make the routing work, just add the path to an endpoint and the class to the Map in the <code>API</code> Class. 
