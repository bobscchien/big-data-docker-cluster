FROM bobscchien/apache-openjdk

LABEL maintainer="Bob Chien <bob.sc.chien@gmail.com>"

ARG FILE PROJECT_PROGRAM PROJECT_DATA 

# Create directories of programs and data
RUN mkdir -p \
	${PROJECT_PROGRAM}/src \
	${PROJECT_DATA}/zookeeper/logs \
	${PROJECT_DATA}/zookeeper/data && \
    touch ${PROJECT_DATA}/zookeeper/data/myid && \
    chmod 777 ${PROJECT_DATA}/zookeeper
	
# Copy the source code from localhost
COPY ${FILE} ${PROJECT_PROGRAM}/src/${FILE}/

# Setup environment
RUN ln -s ${PROJECT_PROGRAM}/src/${FILE} ${PROJECT_PROGRAM}/zookeeper && \
    echo "export PATH=${PROJECT_PROGRAM}/zookeeper/bin:\$PATH" | tee -a /etc/bash.bashrc /home/zookeeper/.bashrc

# Change Owner & User
RUN chown -R zookeeper:zookeeper \
		${PROJECT_PROGRAM}/src/${FILE} \
		${PROJECT_DATA}/zookeeper

USER zookeeper

CMD ["/bin/bash"]
