echo "[deploy] start"

cd /tmp

ls -al

docker load -i /tmp/output.current.tar
docker run -d -p 3000:3000 -it catcatch/backend:latest

echo "[deploy] done"
