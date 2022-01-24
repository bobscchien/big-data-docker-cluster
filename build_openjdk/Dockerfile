# Get the basic image
FROM openjdk:8

# Add metadata to the image as a key value pair. For example, LABEL version="1.0"
LABEL maintainer="Bob Chien <bob.sc.chien@gmail.com>"

ARG PROJECT_PROGRAM PROJECT_CODE PROJECT_DATA 

# Add users
# https://stackoverflow.com/questions/27701930/how-to-add-users-to-docker-container

RUN useradd --create-home --no-log-init --shell /bin/bash zookeeper && echo 'zookeeper:zookeeper' | chpasswd && \
    useradd --create-home --no-log-init --shell /bin/bash kafka && echo 'kafka:kafka' | chpasswd && \
    useradd --create-home --no-log-init --shell /bin/bash hadoop && echo 'hadoop:hadoop' | chpasswd && \
    useradd --create-home --no-log-init --shell /bin/bash hdfs && echo 'hdfs:hdfs' | chpasswd && \
    useradd --create-home --no-log-init --shell /bin/bash yarn && echo 'yarn:yarn' | chpasswd && \
    useradd --create-home --no-log-init --shell /bin/bash spark && echo 'spark:spark' | chpasswd && \
    useradd --create-home --no-log-init --shell /bin/bash hive && echo 'hive:hive' | chpasswd && \
    useradd --create-home --no-log-init --shell /bin/bash hue && echo 'hue:hue' | chpasswd && \
    passwd -d root

# Setup environment
ADD setup_environment.sh /tmp
RUN apt-get update && \
    apt-get install -y \
        ssh openssh-server openssh-client \
        net-tools iproute2 iputils-ping telnet vim && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    /tmp/setup_environment.sh

# Setup directories
RUN mkdir -p $PROJECT_CODE $PROJECT_DATA $PROJECT_PROGRAM/src /tmp/scripts /tmp/installation && \
    chmod 777 $PROJECT_CODE $PROJECT_DATA $PROJECT_PROGRAM/src /tmp/scripts /tmp/installation

CMD ["/bin/bash"]
