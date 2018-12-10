FROM lambda-perl-runtime:5.28

COPY cpanfile .

RUN /opt/runtime/bin/cpanm -n --no-man-pages -l /opt/layer1-lib --installdeps .

# The layer.zip file from the runtime is still present, so we delete it, or else
# the zip command will add the files to the existing file
RUN rm /layer.zip ; \
    cd /opt ; \
    zip -r /layer.zip layer1-lib
