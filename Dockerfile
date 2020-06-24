#
# perlmagick7
#
FROM perl:5.32.0-slim
MAINTAINER Kevin Smith "kevin@spleck.pl"

# update system, add deps, build imagemagick 7, clean up
RUN true && \
	apt-get update && apt-get upgrade -y && \
	apt-get install libstdc++-8-dev curl gnupg \
		libdjvulibre-dev libgvc6 liblqr-1-0-dev libltdl-dev libopenexr-dev libopenjp2-7-dev libwmf-dev \
		ghostscript gsfonts fonts-dejavu libzstd-dev libfftw3-dev libpango1.0-dev libraw-dev \
		libraw1394-dev libpng-dev libgif-dev libjpeg-dev libtiff5-dev git -y && \
	find /usr/local/lib/perl5 -name "libperl.so" -exec ln -s {} /usr/local/lib/libperl.so \; && \
	git clone https://github.com/ImageMagick/ImageMagick.git /opt/ImageMagick --branch 7.0.10-21 && \
	cd /opt/ImageMagick && ./configure --with-perl && make && make install && cd / && rm -rf /opt/ImageMagick && \
	rm -rf /var/lib/apt/lists/*

# secure perl module installs
ENV PERL_CPANM_OPT --verbose --mirror https://cpan.metacpan.org --mirror-only
RUN cpanm Digest::SHA Module::Signature && rm -rf ~/.cpanm
ENV PERL_CPANM_OPT $PERL_CPANM_OPT --verify

CMD ["perl5.32.0","-de0"]
