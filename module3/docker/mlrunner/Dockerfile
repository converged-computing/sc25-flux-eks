FROM 633731392008.dkr.ecr.us-east-1.amazonaws.com/mini-mummi:mlrunner-arm
COPY ./entrypoint.sh /entrypoint.sh
RUN yum update -y && yum install -y tree
ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]
