FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

USER root

# 第一层：基础工具包（最稳定、最少变更）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# 第二层：调试和网络工具（可能变更）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    vim \
    net-tools \
    iputils-ping \
    procps \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# 安装 Node.js (更推荐的官方方法)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get update && \
    apt-get install -y  nodejs && \
    rm -rf /var/lib/apt/lists/*

# 只安装 PostgreSQL 客户端（如果不需要服务端）
RUN apt-get update && \
    apt-get install -y wget ca-certificates gnupg lsb-release && \
    mkdir -p /usr/share/keyrings && \
    wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > /usr/share/keyrings/postgresql.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" \
        > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get install -y postgresql-client-14 && \
    rm -rf /var/lib/apt/lists/*