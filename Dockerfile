FROM eclipse-temurin:17-jre-alpine AS builder

ARG CTAKES_VERSION=6.0.0
ENV CTAKES_HOME=/apache-ctakes-${CTAKES_VERSION}

RUN apk update && apk add ca-certificates openssl wget unzip

## ~1.7G
RUN wget --show-progress -q -O /apache-ctakes.zip https://github.com/apache/ctakes/releases/download/ctakes-${CTAKES_VERSION}/apache-ctakes-${CTAKES_VERSION}-bin.zip 
RUN unzip -o /apache-ctakes.zip -d / && \
    rm /apache-ctakes.zip

RUN wget --show-progress -q -O /apache-ctakes-resources.zip http://sourceforge.net/projects/ctakesresources/files/ctakes-resources-4.0-bin.zip
RUN unzip /apache-ctakes-resources.zip -d /ctakes-resources-4.0 && \
    rm /apache-ctakes-resources.zip && \
    cp -r /ctakes-resources-4.0/resources/org/apache/ctakes/dictionary/lookup/*  /${CTAKES_HOME}/resources/org/apache/ctakes/dictionary/lookup/ && \
    rm -r /ctakes-resources-4.0

ENV PATH="${PATH}:${CTAKES_HOME}/bin"

RUN touch /root/setenv.sh

ENV UMLS_API_KEY=""

RUN echo 'export UMLS_API_KEY=${UMLS_API_KEY}' > /root/setenv.sh

RUN mkdir /input /output /custom_piper

COPY data/sample_input/sample_patient.txt /input/input.txt

ENV PIPER_FILE_PATH="/apache-ctakes-6.0.0/resources/org/apache/ctakes/clinical/pipeline/DefaultFastPipeline.piper"
ENV INPUT_FILE_PATH="/input/input.txt"
ENV OUTPUT_FILE_DIR="/output"


ENTRYPOINT java -Dlog4j.configuration=file:/apache-ctakes-6.0.0/config/log4j2.xml -cp "/apache-ctakes-6.0.0/desc/:/apache-ctakes-6.0.0/resources/:/apache-ctakes-6.0.0/lib/*" org.apache.ctakes.core.pipeline.PiperFileRunner -p "${PIPER_FILE_PATH}" -i "${INPUT_FILE_PATH}" --xmiOut "${OUTPUT_FILE_DIR}" --key "${UMLS_API_KEY}"

