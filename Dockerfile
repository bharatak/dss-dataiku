FROM dataiku/dss:4.1.0

# Entry point
WORKDIR /home/dataiku

COPY run.sh /home/dataiku/

EXPOSE $DSS_PORT

USER root

CMD [ "/home/dataiku/run.sh" ]
