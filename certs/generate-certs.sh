openssl req -x509 -newkey rsa:2048 -keyout gateway-key.pem -out gateway-cert.pem -days 365 -nodes -subj "/CN=tyk-gateway"
openssl req -x509 -newkey rsa:2048 -keyout client-key.pem -out client-cert.pem -days 365 -nodes -subj "/CN=api-client"

# mutual-tls testing
# openssl pkcs12 -export -out client-cert.pfx -inkey client-key.pem -in client-cert.pem
# openssl pkcs12 -export -out gateway-cert.pfx -inkey gateway-key.pem -in gateway-cert.pem
# curl --tlsv1.2 https://localhost:8080/simple-api/ --cacert gateway-cert.pfx -k --cert client-cert.pfx:password
