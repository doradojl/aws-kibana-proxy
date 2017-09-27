FROM node:5.7.1-onbuild
EXPOSE 3000
ENV WORKERS=5 \
    CONFIG='{  "session_secret": "dont share the secret",  "port": 3000,  "es": {    "host": "search-atlas-9333-c2aw4aqcaub5u2zc5zgire4mzy.eu-west-1.es.amazonaws.com",    "region": "eu-west-1",    "credentials": {      "accessKeyId": "AKIAILUKOGNTQTSL2P7Q",      "secretAccessKey": "9uP82fOvwVr83spSQVBh5XlnZosihOorroQ\/DsAE"    }  },  "auth": {    "protocol" : "http",    "host": "dev-kibana.aveng.us",    "port":"3000",    "oauth_client_id": "869883453945-mjj1m5p9ma9pa4hnu591r2l270h7ltc5.apps.googleusercontent.com",    "oauth_client_secret": "co3B6XSDXI5w5QeAQevm6qLW",    "allowed_domain": "alienvault.com"  }}'

RUN \
  useradd -ms /bin/false app_user && \
  chown -R app_user:app_user /usr/src/app

RUN npm install -g pm2
RUN mkdir -p /conf/

CMD echo $CONFIG > /conf/config.json && pm2 -v && pm2 start -i $WORKERS --no-daemon --user app_user proxy.js -- --config /conf/config.json
