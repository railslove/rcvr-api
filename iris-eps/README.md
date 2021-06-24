# rcvr-iris-eps
Eps server for iris connection


install heroku cli
 
build with 

docker build . -t rcvr-eps

heroku actions:

    heroku container:login

    deploy to heroku with heroku container:
        push rcvr-eps -a rcvr-iris-eps


#run locally to expose to localhost and use curl to connect
#docker run --network="host" rcvr-eps

#example query according to iris doks

curl --header "Content-Type: application/json" --request POST --insecure --data '
{
    "method":"ls-1.postLocationsToSearchIndex",
    "id": "1",
    "params": {
        "locations": [
            {
                "id": "1abc",
                "name": "Visits Test"
            }
        ]
    },
    "jsonrpc": "2.0"
}
' https://localhost:5556/jsonrpc




