FROM lambci/lambda:build

RUN curl -s -o perl-5.28.1.tar.gz http://www.cpan.org/src/5.0/perl-5.28.1.tar.gz ; \
    tar xzf perl-5.28.1.tar.gz ; \
    cd perl-5.28.1 ; \
    ./Configure -des -Dprefix=/opt/runtime -Dman1dir=none -Dman3dir=none ; \
    make ; \
    make install ; \
    cd /opt ; \
    zip -r /layer.zip runtime

