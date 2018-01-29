# JWT Integration with Tyk Using Keycloak

### Create the KeyCloak Realm, Client and User
```bash
# Open the KeyCloak console 
#   username: admin
#   password: admin123
open http://localhost:38080/auth/admin/

# Add a realm, name = "tyk"
# Create a client, client ID = "tyk-client"
# Create a user, username = "tyk-user"
# Amend user, password = "password12", non-temporary password
```

### Create a JWT using KeyCloak
```bash

docker exec -it tykquickstart_tyk_gateway_1 bash

  export CLIENT_ID=tyk-client
  export USERNAME=tyk-user
  export PASSWORD=password12
  
  curl -X POST http://keycloak:8080/auth/realms/Tyk/protocol/openid-connect/token -H "Content-Type: application/x-www-form-urlencoded" -d "username=$USERNAME" -d "password=$PASSWORD" -d "grant_type=password" -d "client_id=$CLIENT_ID"
  
# use https://jwt.io/ to view token attributes

# validate the signature with the RSA public key...
# remember to prepend with...
# -----BEGIN PUBLIC KEY-----
# ...and append with...
# -----END PUBLIC KEY-----

```

### Create an JWT-Protected API in Tyk
```bash
# Open the Tyk Dashboard
#   username: test@test.com
#   password: test123
open http://localhost:3000

# Create an API
#   name: simple-api
#   target URL: http://simple-api:8080
#   authentication mode: JWT
#   jwt signing method: RSA Public Key
#   secret: 
#       -----BEGIN PUBLIC KEY-----
#       <public-key>
#       -----END PUBLIC KEY-----
#   identity source: sub
#   policy field name: policy-id

curl https://localhost:8080/simple-api/ -k

# Create a policy, making a note of the created policy-id
#   name: simple-api-policy
#   rate limit: 100 requests per second
#   access rights: simple-api
```

### Add Mapper for Tyk Policy in KeyCloak
```bash
# Open the KeyCloak console 
#   username: admin
#   password: admin123
open http://localhost:38080/auth/admin/

# For the "tyk" client, add a hardcoded claim
#   name: policy-id mapper
#   token claim name: policy-id
#   token claim value: <Tyk policy

# Create a JWT as before, validate the new claim is visible

export AUTH_CODE=<access-token-from-jwt>
curl https://localhost:8080/simple-api/ --header "Authorization: $AUTH_CODE" -k
```

### Test the Policy Integration with Gatling
```bash
docker exec -it tykquickstart_gatling_1 sh

cp user-files/simulations/SimpleAPISimulation.scala.dist user-files/simulations/SimpleAPISimulation.scala

# set key to a valid JWT access-token
vi user-files/simulations/SimpleAPISimulation.scala

bin/gatling.sh
```