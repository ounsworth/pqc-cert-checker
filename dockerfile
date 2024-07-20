FROM openquantumsafe/oqs-ossl3
WORKDIR /usr/local/app

# Copy in the source code
COPY src ./src

# Setup an app user so the container doesn't run as the root user
RUN useradd app
USER app

CMD ["entrypoint.sh"]
 