# latest == latest stable version
# main == latest dev version
FROM lovasoa/sqlpage:latest

LABEL 	vendor="changeme" \
	product="changeme" \
        version="vVERSIONNUMBERPLACEHOLDER" \
    	maintainer="changeme"

USER root
WORKDIR /var/www
COPY --chown=sqlpage:sqlpage ./src/ .
COPY --chown=sqlpage:sqlpage ./config/ /etc/sqlpage

USER sqlpage