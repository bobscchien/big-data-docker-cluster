FROM bobscchien/apache-openjdk

LABEL maintainer="Bob Chien <bob.sc.chien@gmail.com>"

ARG FILE_SPARK FILE_HADOOP PROJECT_PROGRAM PROJECT_DATA 

# Create directories of programs and data
RUN mkdir -p \
	${PROJECT_PROGRAM}/src \
	${PROJECT_DATA}/hadoop/tmp/name \
	${PROJECT_DATA}/hadoop/tmp/data \
	${PROJECT_DATA}/hadoop/tmp/journal && \
	chmod -R 777 ${PROJECT_DATA}/hadoop

# Copy the source code from localhost
COPY ${FILE_SPARK} ${PROJECT_PROGRAM}/src/${FILE_SPARK}/
COPY ${FILE_HADOOP} ${PROJECT_PROGRAM}/src/${FILE_HADOOP}/
COPY Env.sh /tmp

# Setup environment
RUN ln -s ${PROJECT_PROGRAM}/src/${FILE_SPARK} ${PROJECT_PROGRAM}/spark && \
	ln -s ${PROJECT_PROGRAM}/src/${FILE_HADOOP} ${PROJECT_PROGRAM}/hadoop && \
    cat /tmp/Env.sh | tee -a /etc/bash.bashrc /home/hadoop/.bashrc
	
# Change Owner & User
RUN chown -R hadoop:hadoop \
		${PROJECT_PROGRAM}/src/${FILE_SPARK} \
		${PROJECT_PROGRAM}/src/${FILE_HADOOP} \
		${PROJECT_DATA}/hadoop

USER hadoop

CMD ["/bin/bash"]
