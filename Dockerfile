FROM debian:stretch
LABEL maintainer "Jefferson J. Hunt <jeffersonjhunt@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# Ensure that we always use UTF-8, US English locale and UTC time
RUN apt-get update && apt-get install -y locales \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
  && echo "UTC" > /etc/timezone \
  && chmod 0755 /etc/timezone
ENV LANG en_US.utf8
ENV LC_ALL=en_US.utf-8
ENV LANGUAGE=en_US:en
ENV PYTHONIOENCODING=utf-8

# Install Base Apps
RUN apt-get install -y \
    python \
    curl \
    # sigh this is needed to support shinysdr/fetch-js-deps.sh
    wget \
    vim-nox \
    git

WORKDIR /opt

# Install Supporting Apps
RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py \
  && python /tmp/get-pip.py \
  && pip install --upgrade pip \
  && apt-get install -y \
    gnuradio \
    gnuradio-dev \
    gr-osmosdr

# Run build and install ShinySDR
RUN git clone https://github.com/kpreid/shinysdr/ \
  && cd shinysdr \
  && ./fetch-js-deps.sh \
  # this should be added to fetch-js-deps.sh
  && pip install --upgrade service_identity \
  # this should be added to fetch-js-deps.sh
  && pip install --upgrade pyasn1-modules \
  && python setup.py build \
  && python setup.py install

# Clean up APT when done.
RUN apt-get autoclean -y && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add mgmt scripts
COPY shinysdr-entrypoint.sh /usr/local/bin/shinysdr-entrypoint.sh
RUN chmod +x /usr/local/bin/shinysdr-entrypoint.sh

# Fire it up!
EXPOSE 8100 8101
ENTRYPOINT ["shinysdr-entrypoint.sh"]
CMD ["start"]

# Fin