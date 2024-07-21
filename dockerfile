FROM openquantumsafe/oqs-ossl3:latest

# Copy in the source code
COPY src /

CMD ["/entrypoint.sh"]
#  CMD ["true"]