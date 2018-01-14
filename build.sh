echo "build polylines"
(cd ./polylines && ./docker_extract.sh)
echo "build placeholder"
(cd ./placeholder && yarn build)
