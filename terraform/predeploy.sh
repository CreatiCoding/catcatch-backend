echo "[pre:deploy] start"

cd ..

rm ./terraform/output.current.tar
ls -al /terraform

nerdctl build --no-cache -t catcatch/backend:latest \
  --build-arg GOOGLE_OAUTH_CLIENT_ID=$GOOGLE_OAUTH_CLIENT_ID \
  --build-arg GOOGLE_OAUTH_CLIENT_SECRET=$GOOGLE_OAUTH_CLIENT_SECRET \
  --build-arg GOOGLE_OAUTH_REDIRECT_URI=$GOOGLE_OAUTH_REDIRECT_URI \
  --build-arg GOOGLE_OAUTH_DEFAULT_SCOPE=$GOOGLE_OAUTH_DEFAULT_SCOPE \
  .

nerdctl images

currentOutput=output-$RANDOM.tar

nerdctl save -o $currentOutput catcatch/backend

cp $currentOutput ./terraform/output.current.tar
mv $currentOutput ./output.backup

ls -al ./terraform

echo "[pre:deploy] done"
