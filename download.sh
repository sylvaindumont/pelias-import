echo "download whosonfirst"
(cd ./whosonfirst && yarn download)
echo "download openaddresses"
(node download/openaddresses.js)
echo "download openstreetmap"
(node download/openstreetmap.js)
echo "download placeholder"
(node download/placeholder.js)
