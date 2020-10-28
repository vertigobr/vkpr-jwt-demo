## Description
The idea of this project is to be able to test the Keycloak capabilities for it's Open ID solution.

It's a simples Spring boot application that manages to use the KeycloakAuthenticationProvider to check on Keycloak if the JWT tokens that are being received are valid ones.

It will expose some endpoints that can be accessed only with a JWT that represent specific sample roles. 
 
We use this project to test the [VKPR project](https://github.com/vertigobr/vkpr) running on the local machine, 
with the values-local-vault-http configuration set. 

## Requirements:
- Java 11 
- Maven
- Keycloak server 
    
Java 13 and beyond will isn't fully suported by Keycloak starter, 
it will send the error "ClassNotFoundException: java.security.acl.Group"


## Keycloak setup
The Keycloak server should have a Realm with the following characteristics:

Client 
 - client protocol: openid-connect 
 - access type: confidential
 - service accounts enabled
 - authorization enabled
 - 2 types of custom roles created: User and Admin

Roles 
 - two roles with Composite Roles option enabled, mapping to the Client roles

Users
 - two different users 
 - map each other with a specific Role
 
## Running the app
First we need to configure the configuration file properly, so it can reach our Keycloak server.

In our example this is how it's configured:
```yaml
server:
  port: 8000

keycloak:
  auth-server-url: http://vkpr-keycloak-http.default.svc/auth
  realm: springboot
  ssl-required: external
  use-resource-role-mappings: true
  bearer-only: true
  resource: springboot-client
  credentials:
    secret: e28e961b-2f86-4877-a696-b76cd231105e
```
Where:
- auth-server-url should be configured with the Discovery URL of the Keycloak server
- real should match the realm where you created the client
- resource should match the client id
- credentials.secret is the client secret

So, you will need to package the app with all of it's dependencies and then run

  ```
mvn clean install  
mvn spring-boot:run
  ```
 
To test, it will require 2 steps
- Get the JWT token
- Access our Springboot API with that Token

### Get the JWT Token
We will simply make a curl to the URL:
```
http://<KEYCLOAK_SERVER_HOST>/auth/realms/<REALM_NAME>/protocol/openid-connect/token
```
Passing the Client ID and Secret that we will use (since it's a Confidential access type client), 
and the username and password of the user we want to gather a JWT from.

```
curl -L -X POST 'http://vkpr-keycloak-http.default.svc/auth/realms/springboot/protocol/openid-connect/token' \
    --data-urlencode 'client_id=springboot-client' \
    --data-urlencode 'client_secret=e28e961b-2f86-4877-a696-b76cd231105e' \
    --data-urlencode 'username=user-simple' \
    --data-urlencode 'password=vert1234' \
    --data-urlencode 'grant_type=password'
```

We need to store the Access Token that will be obtained as a response, since it will be used on the next step.


### Access the API
To access the api we will pass the Access Token on the Authorization Header.

The available endpoints under /api are
- /user 
    will accept every JWT that contains the role User
- /admin
    will accept every JWT that contains the role Admin
- /anonymous
    will accept every call with or without the Authorization header
- /all-user
    will accept every JWT that contains the role User or Admin

In this case we want to access the URI /api/user.

```
curl -L -X GET 'http://localhost:8000/api/user' \ 
--header 'Authorization: Bearer <ACCESS_TOKEN>'

```

If the Token we obtained matches the "user" role, we will receive a "Hello world" 200 message back.
Otherwise, we will receive an 403 error message. 


### Based on:
- https://www.baeldung.com/spring-boot-keycloak
- https://github.com/novomatic-tech/keycloak-examples
- https://medium.com/devops-dudes/securing-spring-boot-rest-apis-with-keycloak-1d760b2004e
