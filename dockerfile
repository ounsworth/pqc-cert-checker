FROM openquantumsafe/oqs-ossl3
WORKDIR /usr/local/app

# Copy in the source code
COPY src ./src

# Copy in the X.509 artifacts to test
COPY artifacts ./artifacts

# Setup an app user so the container doesn't run as the root user
RUN useradd app
USER app

CMD ["entrypoint.sh"]