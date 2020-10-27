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

### Based on:
- https://www.baeldung.com/spring-boot-keycloak
- https://github.com/novomatic-tech/keycloak-examples
- https://medium.com/devops-dudes/securing-spring-boot-rest-apis-with-keycloak-1d760b2004e
