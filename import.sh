# start elasticsearch if it's not already running
if ! [ $(curl --output /dev/null --silent --head --fail http://elasticsearch:9200) ]; then
    # wait for elasticsearch to start up
    echo 'waiting for elasticsearch service to come up';
    until $(curl --output /dev/null --silent --head --fail http://elasticsearch:9200); do
      printf '.'
      sleep 2
    done
fi

echo "prepare schema"
(cd ./schema && yarn create_index)
echo "import whosonfirst"
(cd ./whosonfirst && yarn start)
echo "import openaddresses"
(cd ./openaddresses && yarn start)
echo "import openstreetmap"
(cd ./openstreetmap && yarn start)
echo "import polylines"
(cd ./polylines && yarn start)
