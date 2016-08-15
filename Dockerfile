FROM alpine:3.4
MAINTAINER Nicholas Wiersma <nick@wiersma.co.za>

ENV VERSION master
ENV CHEETAH 2.4.4

# Create user and group for SickBeard.
RUN addgroup -S -g 666 sickbeard \
    && adduser -S -u 666 -G sickbeard -h /sickbeard -s /bin/sh sickbeard

# Install Dependencies
RUN apk add --no-cache ca-certificates py-openssl openssl git \
    && wget -O- https://pypi.python.org/packages/source/C/Cheetah/Cheetah-$CHEETAH.tar.gz | tar -zx \
    && cd Cheetah-$CHEETAH \
    && python setup.py install \
    && cd .. \
    && rm -rf Cheetah-$CHEETAH

# Add SickBeard init script.
ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

# Define container settings.
VOLUME ["/datadir", "/download", "/media"]

EXPOSE 8081

# Start SickBeard.
WORKDIR /sickbeard

CMD ["/entrypoint.sh"]
