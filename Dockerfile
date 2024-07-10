# Pull a pre-built alpine docker image with nginx and python3 installed
FROM tiangolo/uwsgi-nginx:python3.8-alpine-2020-12-19

# Set the port on which the app runs; make both values the same.
#
# IMPORTANT: When deploying to Azure App Service, go to the App Service on the Azure 
# portal, navigate to the Applications Settings blade, and create a setting named
# WEBSITES_PORT with a value that matches the port here (the Azure default is 80).
# You can also create a setting through the App Service Extension in VS Code.
ENV LISTEN_PORT=5000
EXPOSE 5000

# Indicate where uwsgi.ini lives
ENV UWSGI_INI uwsgi.ini

# Tell nginx where static files live. Typically, developers place static files for
# multiple apps in a shared folder, but for the purposes here we can use the one
# app's folder. Note that when multiple apps share a folder, you should create subfolders
# with the same name as the app underneath "static" so there aren't any collisions
# when all those static files are collected together.
ENV STATIC_URL /hello_app/static

# Set the folder where uwsgi looks for the app
WORKDIR /hello_app

# Copy the app contents to the image
COPY . /hello_app

# If you have additional requirements beyond Flask (which is included in the
# base image), generate a requirements.txt file with pip freeze and uncomment
# the next three lines.
#COPY requirements.txt /
#RUN pip install --no-cache-dir -U pip
#RUN pip install --no-cache-dir -r /requirements.txt
ENTRYPOINT /webapp.py

# Twistlock Container Defender - app embedded
ADD twistlock_defender_app_embedded.tar.gz /tmp
ENV DEFENDER_TYPE="appEmbedded"
ENV DEFENDER_APP_ID="apiserver"
ENV FILESYSTEM_MONITORING="true"
ENV WS_ADDRESS="wss://app0.cloud.twistlock.com:443"
ENV DATA_FOLDER="/tmp"
ENV INSTALL_BUNDLE="eyJzZWNyZXRzIjp7InNlcnZpY2UtcGFyYW1ldGVyIjoieUY5Zmg5djhXbnlQelpPV0xjd2RBcDZSVC9GTHpwZWJ3eWYvTWtHaU5Ud2RFK1daNFFTMVhZeG9RYjJrYjVaL2xSRkFLSFVrbXNxSWhqYUFSRWRsdWc9PSJ9LCJnbG9iYWxQcm94eU9wdCI6eyJodHRwUHJveHkiOiIiLCJub1Byb3h5IjoiIiwiY2EiOiIiLCJ1c2VyIjoiIiwicGFzc3dvcmQiOnsiZW5jcnlwdGVkIjoiIn19LCJjdXN0b21lcklEIjoiYXBwMC05MzA4MTg5MyIsImFwaUtleSI6ImhWbFpUekxlU2dpbTAwV3BDU1oxNkIyUGVnWEFXbXh2TmpYVDhWODIycWxRVi96b2VqTGkxMG9qTEZBOFBPc2dhV0tIK2NLaC9BaW5idlZFeDBia053PT0iLCJtaWNyb3NlZ0NvbXBhdGlibGUiOmZhbHNlLCJpbWFnZVNjYW5JRCI6ImRhNDU3MzUyLWZiYTMtOTMwZS0xMjFmLTdjMWY1M2Q2OWY3OSJ9"
ENV FIPS_ENABLED="false"
ENTRYPOINT exec /tmp/defender app-embedded /bin/sh -c '/webapp.py'
