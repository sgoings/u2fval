FROM python:2.7.10

WORKDIR /u2fval

# install prerequisites for u2fval
RUN apt-get update && \
    apt-get install -y --no-install-recommends libssl-dev \
                                               python-m2crypto \
                                               swig \
                                               sqlite3

# jessie has the opensslcon.h in a different place than M2Crypto expects
RUN ln -s /usr/include/x86_64-linux-gnu/openssl/opensslconf.h /usr/include/openssl/

ADD . /u2fval

# build u2fval
RUN python setup.py install

# create a source distribution
RUN python setup.py sdist

# copy default configuration into place
COPY conf/u2fval.conf /etc/yubico/u2fval/

# create db
RUN u2fval db init

EXPOSE 8080

# run u2fval accepting connections on all interfaces
CMD [ "u2fval", "run", "-i", "0.0.0.0" ]
