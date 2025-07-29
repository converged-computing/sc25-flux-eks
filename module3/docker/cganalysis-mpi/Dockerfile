FROM 633731392008.dkr.ecr.us-east-1.amazonaws.com/mini-mummi:cganalysis-arm

# We are going to nuke and reinstall miniconda deps. If we don't there are version clashes.
RUN rm -rf /miniconda3
WORKDIR /miniconda3
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py311_23.11.0-1-Linux-aarch64.sh && \
    bash Miniconda3-py311_23.11.0-1-Linux-aarch64.sh -b -u -p /miniconda3 && \
    rm -rf Miniconda3-py311_23.11.0-1-Linux-aarch64.sh

RUN conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda install --yes -c pytorch -c conda-forge gromacs=*=mpi* pandas scikit-learn xgboost h5py scipy networkx faiss-cpu keras keras-preprocessing keras-applications

RUN cd /opt/clones/mummi-core && \
    pip install -e . && \
    cd /opt/clones/mummi-ras && \
    pip install -e . && \
    pip install MDAnalysis --upgrade && \
    # unused dependency
    pip install redis

COPY ./entrypoint.sh /entrypoint.sh
COPY ./simulation.py /opt/clones/mummi-ras/mummi_ras/online/simulation.py
# This is createsims output from /workdir/out
COPY ./data /tmp/out
ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]
