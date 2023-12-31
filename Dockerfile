FROM  ubuntu:22.04

RUN apt-get update
RUN apt-get install -y unzip
RUN apt-get install -y zip
RUN apt-get install -y git
RUN apt-get install -y curl

RUN apt-get install -y --no-install-recommends openjdk-11-jdk
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
	apt-get install -qq -y apt-utils locales
RUN apt-get install -qq --no-install-recommends \
	autoconf \
	build-essential \
	cmake \
	file \
	git-lfs \
	gpg-agent \
	less \
	libc6-dev \
	libgmp-dev \
	libmpc-dev \
	libmpfr-dev \
	libxslt-dev \
	libxml2-dev \
	m4 \
	ncurses-dev \
	ocaml \
	openssh-client \
	pkg-config \
	software-properties-common \
	tzdata \
	vim-tiny \
	wget \
	zipalign \
	python3-pip \
	zlib1g-dev > /dev/nul \
	&& apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/* && \
	echo 'debconf debconf/frontend select Dialog' | debconf-set-selections

ENV ANDROID_HOME="/opt/android-sdk" \
	ANDROID_SDK_HOME="/opt/android-sdk" \
	ANDROID_SDK_ROOT="/opt/android-sdk" \
	ANDROID_NDK="/opt/android-sdk/ndk/latest" \
	ANDROID_NDK_ROOT="/opt/android-sdk/ndk/latest"

ENV ANDROID_SDK_MANAGER=${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager
ENV ANDROID_SDK_HOME="$ANDROID_HOME"
ENV ANDROID_NDK_HOME="$ANDROID_NDK"

RUN curl -o sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip

RUN mkdir --parents "$ANDROID_HOME" && \
	unzip -q sdk-tools.zip -d "$ANDROID_HOME" && \
	cd "$ANDROID_HOME" && \
	mv cmdline-tools latest && \
	mkdir cmdline-tools && \
	mv latest cmdline-tools && \
	rm --force sdk-tools.zip


ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
ENV ANDROID_SDK_HOME="$ANDROID_HOME"
ENV ANDROID_NDK_HOME="$ANDROID_NDK"

ENV AAPT_HOME="${ANDROID_HOME}/build-tools/33.0.2"

ENV PATH="$AAPT_HOME:$JAVA_HOME/bin:$PATH:$ANDROID_SDK_HOME/emulator:$ANDROID_SDK_HOME/cmdline-tools/latest/bin:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools"

RUN mkdir --parents "$ANDROID_HOME/.android/"
RUN echo '### User Sources for Android SDK Manager' > "$ANDROID_HOME/.android/repositories.cfg"

RUN echo "platforms" && yes | $ANDROID_SDK_MANAGER "platforms;android-33"

RUN yes | $ANDROID_SDK_MANAGER "build-tools;33.0.2"

VOLUME [ "/root/.gradle", "/projects"]

