ARG PLATFORM=amd64
FROM ${PLATFORM}/debian:10-slim
LABEL maintainer "Jefferson J. Hunt <jeffersonjhunt@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV MAKEFLAGS=-j8

# Ensure that we always use UTF-8, US English locale and UTC time
RUN apt-get update && apt-get install -y locales && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
  echo "UTC" > /etc/timezone && \
  chmod 0755 /etc/timezone 
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.utf-8
ENV LANGUAGE=en_US:en
ENV PYTHONIOENCODING=utf-8

COPY assets/* /tmp/

# Install supporting apps needed to build/run
RUN apt-get install -y \
      git \
      build-essential \
      cmake \
      cmake-data \
      pkg-config \
      doxygen \
      swig \
      texinfo \
      dh-autoreconf \
      python \
      python-dev \
      gfortran \
      gr-osmosdr \
      gnuradio \
      gnuradio-dev \
      libudev-dev \
      libusb-1.0-0-dev \
      qttools5-dev \
      qttools5-dev-tools \
      qtmultimedia5-dev \
      libqt5serialport5-dev \
      libssl-dev \
      libffi-dev \
      libfftw3-dev && \
    python /tmp/get-pip.py && \
    pip install --upgrade pip

WORKDIR /build

# Add modules/plugins
RUN tar zxvf /tmp/wsjtx-2.1.2.tgz && \
  cd wsjtx-2.1.2 && \
  mkdir build && cd build && \
  cmake -DWSJT_SKIP_MANPAGES=ON -DWSJT_GENERATE_DOCS=OFF ../ && \
  cmake --build . && cmake --build . --target install && ldconfig && \
  cd /build && rm -rf wsjtx-2.1.2

RUN git clone https://github.com/bistromath/gr-air-modes.git && \
  cd gr-air-modes && \
  git checkout tags/gr37 && \
  mkdir build && cd build && cmake ../ && make && make install && ldconfig && \
  cd /build && rm -rf /build/gr-air-modes

RUN git clone https://github.com/EliasOenal/multimon-ng.git && \
  cd multimon-ng && \
  mkdir build && cd build && cmake ../ && make && make install && ldconfig && \
  cd /build && rm -rf multimon-ng

RUN git clone https://github.com/pothosware/SoapySDR.git && \
  cd SoapySDR && \
  git fetch --all --tags --prune && \
  git checkout tags/soapy-sdr-0.7.2 && \
  mkdir build && cd build && cmake ../ && make && make install && ldconfig && \
  cd /build && rm -rf SoapySDR

RUN git clone https://github.com/merbanan/rtl_433.git && \
  apt-get install -y librtlsdr-dev && \
  cd rtl_433 && \
  git fetch --all --tags --prune && \
  git checkout tags/20.02 && \
  mkdir build && cd build && cmake ../ && make && make install && ldconfig && \
  cd /build && rm -rf rtl_433

RUN git clone https://github.com/argilo/gr-dsd.git && \
  apt-get install -y libsndfile1-dev libitpp-dev && \
  cd gr-dsd && \
  git checkout maint-3.7 && \
  mkdir build && cd build && cmake ../ && make && make install && ldconfig && \
  cd /build && rm -rf gr-dsd

COPY patches/radioteletype.patch /tmp/radioteletype.patch
RUN git clone https://github.com/bitglue/gr-radioteletype.git && \
  cd gr-radioteletype && \
  patch -p1 < /tmp/radioteletype.patch && \
  mkdir build && cd build && cmake ../ && make && make install && ldconfig && \
  cd /build && rm -rf /build/gr-radioteletype

# Build and install ShinySDR
RUN git clone https://github.com/kpreid/shinysdr.git && \
  cd shinysdr && \
  export PYTHONHTTPSVERIFY=0 && \
  python setup.py build && \
  python setup.py install && \
  export PYTHONHTTPSVERIFY= && \
  cd /build && rm -rf /build/shinysdr

# Clean up APT when done.
RUN apt-get purge -y \
      git \
      build-essential \
      cmake \
      cmake-data \
      pkg-config \
      doxygen \
      swig \
      texinfo \
      dh-autoreconf \
      gnuradio-dev \
      libudev-dev \
      libusb-1.0-0-dev \
      qttools5-dev \
      qttools5-dev-tools \
      qtmultimedia5-dev \
      libqt5serialport5-dev \
      libfftw3-dev && \
  apt-get autoclean -y && \
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
