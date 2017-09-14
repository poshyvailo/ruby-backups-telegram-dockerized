FROM rails:5

# Устанавливаем переменные окружения
ENV GIT_LINK=https://github.com/poshyvailo/backup.git \
    GIT_BRANCH=v4-stable_telegram

# Устанавливаем тестовый репозиторий debian, так как в стабильном устаревшая версия curl
RUN echo "deb http://deb.debian.org/debian stretch main" > /etc/apt/sources.list

# Обновляем список пакетов и устанавливаем необходимые пакеты:
# curl - необходим для управления контейнерами на хост-машине (необходима версия > 7.4.0)
RUN apt-get update \
	&& apt-get install -y \
		curl \
		rsync \
		jq \
		libcurl3 \
		libcurl4-openssl-dev

# Также устанавливаем gem backup
RUN cd /tmp && \
    git clone ${GIT_LINK} -b ${GIT_BRANCH} && \
    cd backup && \
    gem build backup.gemspec && \
    gem install ./backup-4.4.0.gem --no-document && \
    cd .. && \
    rm -rf backup

WORKDIR /root/Backup