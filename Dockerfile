#
# perlmagick7
#
FROM perl:5.30
MAINTAINER Kevin Smith "kevin.smith@ingramcontent.com"

# update system, build imagemagick 7, clean up
RUN true && \
	apt-get update && apt-get upgrade -y && \
	apt-get install libpng-dev libgif-dev libjpeg-dev libexpat1-dev libtiff5-dev -y && \
	find /usr/local/lib/perl5 -name "libperl.so" -exec ln -s {} /usr/local/lib/libperl.so \; && \
	git clone https://github.com/ImageMagick/ImageMagick.git --branch 7.0.8-56 && \
	cd ImageMagick && ./configure --with-perl && make && make install && rm -rf /ImageMagick && \
	rm -rf /var/lib/apt/lists/*

CMD ["perl5.30.0","-de0"]
