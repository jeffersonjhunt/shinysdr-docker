FROM debian:stable-slim
LABEL maintainer "Jefferson J. Hunt <jeffersonjhunt@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# Ensure that we always use UTF-8, US English locale and UTC time
RUN apt-get update && apt-get install -y locales && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
  echo "UTC" > /etc/timezone && \
  chmod 0755 /etc/timezone 
ENV LANG en_US.utf8
ENV LC_ALL=en_US.utf-8
ENV LANGUAGE=en_US:en
ENV PYTHONIOENCODING=utf-8

# Install apps needed to build
RUN apt-get install -y \    
      curl \
      wget \
      vim-nox \
      git \
      build-essential \
      cmake \
      cmake-data \
      pkg-config \
      doxygen \
      swig \
      texinfo \
      dh-autoreconf

# Install Supporting apps & libraries
RUN apt-get install -y \
      python \    
      gfortran \
      gnuradio \
      gnuradio-dev \
      gr-osmosdr \
      libusb-1.0-0-dev \
      qtmultimedia5-dev \
      libqt5serialport5-dev \
      libfftw3-dev && \
  curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
  python /tmp/get-pip.py && \
  pip install --upgrade pip

WORKDIR /opt

# Add modules/plugins python-libhamlib2 (currently no USRP support)

#multimon-ng (for receiving APRS).
#rtl_433 (for receiving miscellaneous telemetry).
#gr-dsd (for receiving digital voice modes supported by DSD).

#
# Hamlib is currently installed by the WSJTX step
#
# RUN curl https://iweb.dl.sourceforge.net/project/hamlib/hamlib/3.3/hamlib-3.3.tar.gz -o /tmp/hamlib-3.3.tar.gz && \
#   tar -zxvf /tmp/hamlib-3.3.tar.gz && \
#   cd hamlib-3.3 && \
#   ./configure --prefix=/usr \
#     --with-python-binding \
#     --with-xml-support && \
#   make && make install && \
#   cd /opt && rm -rf /opt/hamlib-3.3

RUN curl --insecure https://physics.princeton.edu/pulsar/k1jt/wsjtx-2.0.1.tgz -o /tmp/wsjtx-2.0.1.tgz && \
  tar zxvf /tmp/wsjtx-2.0.1.tgz && \
  cd wsjtx-2.0.1 && \
  mkdir build && cd build && \
  cmake -DWSJT_SKIP_MANPAGES=ON -DWSJT_GENERATE_DOCS=OFF ../ && \
  cmake --build . && \
  cmake --build . --target install && \
  cd /opt && rm -rf wsjtx-2.0.1

RUN curl https://codeload.github.com/bistromath/gr-air-modes/zip/master -o /tmp/gr-air-modes.zip && \
  unzip /tmp/gr-air-modes.zip && \
  cd gr-air-modes-master && \
  mkdir build && cd build && cmake ../ && make && make install && ldconfig && \
  cd /opt && rm -rf /opt/gr-air-modes-master

RUN git clone https://github.com/bitglue/gr-radioteletype.git && \
  cd gr-radioteletype && \
  mkdir build && cd build && cmake ../ && make && make install && ldconfig && \
  cd /opt && rm -rf /opt/gr-radioteletype

# Run build and install ShinySDR
RUN git clone https://github.com/kpreid/shinysdr/ && \
  cd shinysdr \
  ./fetch-js-deps.sh && \
  pip install --upgrade service_identity && \
  pip install --upgrade pyasn1-modules && \
  python setup.py build && \
  python setup.py install && \
  cd /opt && rm -rf /opt/shinysdr

# Clean up APT when done.
RUN apt-get purge -y \
      curl \
      wget \
      vim-nox \
      git \
      build-essential \
      cmake \
      cmake-data \
      pkg-config \
      doxygen \
      swig texinfo \
      dh-autoreconf && \
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
