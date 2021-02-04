FROM jenkins/jenkins:lts

ENV ANDROID_SDK_VERSION 30
ENV ANDROID_HOME /opt/android/sdk
ENV ANDROID_URL https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip

ENV GRADLE_VERSION 6.8.1
ENV GRADLE_HOME /opt/gradle
ENV GRADLE_URL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip

USER root

RUN mkdir -p opt/android/sdk/cmdline-tools/ \
    && wget -O /opt/android/sdk/lastest.zip ${ANDROID_URL} \
    && unzip -o /opt/android/sdk/lastest.zip -d /opt/android/sdk/ \
    && rm /opt/android/sdk/lastest.zip \
    && mv /opt/android/sdk/cmdline-tools /opt/android/sdk/lastest \
    && mkdir /opt/android/sdk/cmdline-tools \
    && mv /opt/android/sdk/lastest /opt/android/sdk/cmdline-tools/lastest \
    && yes | sh /opt/android/sdk/cmdline-tools/lastest/bin/sdkmanager --licenses \
    && sh /opt/android/sdk/cmdline-tools/lastest/bin/sdkmanager "platform-tools" "platforms;android-${ANDROID_SDK_VERSION}" \
    && wget -O /opt/gradle.zip ${GRADLE_URL} \
    && unzip -o /opt/gradle.zip -d /opt \
    && rm /opt/gradle.zip \
    && mv /opt/gradle-${GRADLE_VERSION} /opt/gradle \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/*

USER jenkins

RUN /usr/local/bin/install-plugins.sh git gradle gitea android-signing