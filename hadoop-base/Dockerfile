FROM 127.0.0.1:9900/centos-base:latest 

USER grid
ENV aa_path=/mnt/aa \
    file_server=http://aa00:9999/file
WORKDIR $aa_path

COPY bin ./bin
COPY conf ./conf

RUN sudo chown -R grid:grid . \
&& ls -l ./conf/.ssh/ \
&& mkdir ~/.ssh  \
&& chmod  700 ~/.ssh \
&& cp ./conf/.ssh/* ~/.ssh \
&& ./bin/setup-java.sh \
&& ./bin/setup-scala.sh \
&& ./bin/setup-hadoop.sh \
&& ./bin/setup-spark.sh \
&& echo 0.3 > README.md


CMD ["./bin/entrypoint.sh"]



