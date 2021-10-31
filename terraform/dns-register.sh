aws route53domains update-domain-nameservers \
  --region us-east-1 --domain-name creco-aws.com \
  --nameservers \
  Name=$NAME_SERVER_0 \
  Name=$NAME_SERVER_1 \
  Name=$NAME_SERVER_2 \
  Name=$NAME_SERVER_3
