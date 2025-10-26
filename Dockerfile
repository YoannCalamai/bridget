# latest == latest stable version
# main == latest dev version
FROM lovasoa/sqlpage:latest

LABEL 	product="bridget" \
        version="vVERSIONNUMBERPLACEHOLDER" \
    	maintainer="Yoann Calamai <bridget@marmous.net>"

USER root
WORKDIR /var/www
COPY --chown=sqlpage:sqlpage ./src/ .
COPY --chown=sqlpage:sqlpage ./config/ /etc/sqlpage

USER sqlpage