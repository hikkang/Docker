FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime

LABEL maintainer="hikkang"

ENV LC_ALL=C.UTF-8

# 기본 shell을 bash 로 설정, 원래 기본설정은 ["/bin/sh", "-c"] 이라고 함.
# https://docs.docker.com/engine/reference/builder/#:~:text=The%20default%20shell%20on%20Linux%20is%20%5B%22/bin/sh%22%2C%20%22%2Dc%22%5D
SHELL [ "/bin/bash", "-c" ]


ENV PYTHONENCODING=utf8

RUN apt-get update 
RUN apt-get install -y --no-install-recommends locales tzdata

RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

RUN sed -i '/ko_KR.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG ko_KR.UTF-8  
ENV LANGUAGE ko_KR:ko  
ENV LC_ALL ko_KR.UTF-8     


RUN apt-get install -y --no-install-recommends \
    unzip \
    git \
    g++ \
    openjdk-8-jdk \
    python3-dev \
    python3-pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

ARG UID
ARG GID
ARG USER
ARG USER_GROUP_NAME

ENV UID $UID
ENV GID $GID
ENV USER $USER
ENV USER_GROUP_NAME $USER_GROUP_NAME


RUN groupadd -g $GID $USER_GROUP_NAME
RUN adduser $USER -U $UID --gid $GID --quiet --gecos "" --disabled-password
RUN mkdir -p /etc/sudoers.d
RUN touch /etc/sudoers.d/$USER
RUN echo "$USER ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USER
RUN chmod 044 /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/${USER}



ENTRYPOINT ["/bin/bash"]
