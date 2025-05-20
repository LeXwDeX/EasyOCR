FROM docker.io/pytorch/pytorch

ARG service_home="/home/EasyOCR"

ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update -y && \
    apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgl1-mesa-dev \
    git \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    fonts-wqy-zenhei \
    tzdata \
    locales \
    # cleanup
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists

# 设置时区和 locale，防止中文乱码
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# 复制本地 EasyOCR 代码到容器
RUN mkdir -p "$service_home"
COPY . "$service_home"

# Build
RUN cd "$service_home" \
    && python setup.py build_ext --inplace -j 4 \
    && python -m pip install -e .
