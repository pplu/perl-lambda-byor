FROM lambci/lambda:build

# Install perl
RUN curl -s -o perl-5.28.1.tar.gz http://www.cpan.org/src/5.0/perl-5.28.1.tar.gz ; \
    tar xzf perl-5.28.1.tar.gz ; \
    cd perl-5.28.1 ; \
    ./Configure -des -Dprefix=/opt/runtime -Dman1dir=none -Dman3dir=none ; \
    make ; \
    make install

# cpanm is needed for easy installation
RUN curl -s -L https://cpanmin.us | /opt/runtime/bin/perl - App::cpanminus

# modules to include in the base layer
COPY cpanfile /tmp/
RUN cd /tmp ; /opt/runtime/bin/cpanm -n --installdeps .

# just zip it up
RUN cd /opt ; \
    zip -r /layer.zip runtime

