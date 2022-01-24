FROM bobscchien/apache-openjdk

LABEL maintainer="Bob Chien <bob.sc.chien@gmail.com>"

ARG FILE PROJECT_PROGRAM PROJECT_DATA 

# Create directories of programs and data
RUN mkdir -p \
	${PROJECT_PROGRAM}/src \
	${PROJECT_DATA}/kafka/kafka-logs \
	${PROJECT_DATA}/kafka/data && \
	chmod -R 777 ${PROJECT_DATA}/kafka

# Copy the source code from localhost
COPY ${FILE} ${PROJECT_PROGRAM}/src/${FILE}/

# Setup environment
RUN ln -s ${PROJECT_PROGRAM}/src/${FILE} ${PROJECT_PROGRAM}/kafka && \
    echo "export PATH=${PROJECT_PROGRAM}/kafka/bin:\$PATH" | tee -a /etc/bash.bashrc /home/kafka/.bashrc
    
# Change Owner & User
RUN chown -R kafka:kafka \
		${PROJECT_PROGRAM}/src/${FILE} \
		${PROJECT_DATA}/kafka

USER kafka

CMD ["/bin/bash"]
