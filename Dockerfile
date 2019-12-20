#
# perlmagick7
#
FROM perl:5.30.1
MAINTAINER Kevin Smith "kevin.smith@ingramcontent.com"

# update system, remove imagemagick 6 files, build imagemagick 7, clean up
RUN true && \
	apt-get update && apt-get upgrade -y && \
	apt-get remove --autoremove --purge -y imagemagick-6-common libmagickcore-6.q16-3  libmagickwand-6-headers libmagickwand-6.q16-dev libmagickwand-6.q1 && \
	apt-get install \
		libdjvulibre-dev libgvc6 liblqr-1-0-dev libltdl-dev libopenexr-dev libopenjp2-7-dev libwmf-dev \
		ghostscript gsfonts fonts-dejavu libzstd-dev libfftw3-dev libpango1.0-dev libraw-dev \
		libraw1394-dev libpng-dev libgif-dev libjpeg-dev libtiff5-dev -y && \
	find /usr/local/lib/perl5 -name "libperl.so" -exec ln -s {} /usr/local/lib/libperl.so \; && \
	git clone https://github.com/ImageMagick/ImageMagick.git /ImageMagick --branch 7.0.9-8 && \
	cd /ImageMagick && ./configure --with-perl && make && make install && rm -rf /ImageMagick && \
	rm -rf /var/lib/apt/lists/*

# secure perl module installs
ENV PERL_CPANM_OPT --verbose --mirror https://cpan.metacpan.org --mirror-only
RUN cpanm Digest::SHA Module::Signature && rm -rf ~/.cpanm
ENV PERL_CPANM_OPT $PERL_CPANM_OPT --verify

CMD ["perl5.30.1","-de0"]
