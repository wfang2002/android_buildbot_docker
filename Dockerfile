FROM reactnativecommunity/react-native-android:3.2
# Basic react-native environment
# NDK_VERSION=20.1.5948944
# buildToolsVersion = "30.0.3"
# gradle version = 6.5
# fastlane

WORKDIR /

# Downloading and installing Gradle
# 1- Define a constant with the version of gradle you want to install
ARG GRADLE_VERSION=6.5

# 2- Define the URL where gradle can be downloaded from
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions

# 3- Define the SHA key to validate the gradle download
#    obtained from here https://gradle.org/release-checksums/
ARG GRADLE_SHA=23e7d37e9bb4f8dabb8a3ea7fdee9dd0428b9b1a71d298aefd65b11dccea220f

# 4- Create the directories, download gradle, validate the download, install it, remove downloaded file and set links
RUN mkdir -p /usr/share/gradle /usr/share/gradle/ref \
  && echo "Downlaoding gradle hash" \
  && curl -fsSL -o /tmp/gradle.zip ${GRADLE_BASE_URL}/gradle-${GRADLE_VERSION}-bin.zip \
  \
  && echo "Checking download hash" \
  && echo "${GRADLE_SHA}  /tmp/gradle.zip" | sha256sum -c - \
  \
  && echo "Unziping gradle" \
  && unzip -d /usr/share/gradle /tmp/gradle.zip \
   \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/gradle.zip \
  && ln -s /usr/share/gradle/gradle-${GRADLE_VERSION} /usr/bin/gradle

# 5- Define environmental variables required by gradle
ENV GRADLE_VERSION 6.5
ENV GRADLE_HOME /usr/bin/gradle
ENV GRADLE_USER_HOME /cache

ENV PATH $PATH:$GRADLE_HOME/bin
ENV LANG en_US.UTF-8

VOLUME $GRADLE_USER_HOME

RUN gem install fastlane

# generate ssh key for installing npm package from github
RUN cat /dev/zero | ssh-keygen -q -N ""

# install package for postinstall
RUN npm i -g jetifier
RUN npm i -g opencollective-postinstall
