FROM openquantumsafe/oqs-ossl3
WORKDIR /usr/local/app

# Copy in the source code
COPY src /src

CMD ["entrypoint.sh"]
 