# gets the docker image of ruby 2.5 and lets us build on top of that
FROM ruby:2.7.0

# install rails dependencies
RUN touch /etc/apt/apt.conf.d/99fixbadproxy \
    && echo "Acquire::http::Pipeline-Depth 0;" >> /etc/apt/apt.conf.d/99fixbadproxy \
    && echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf.d/99fixbadproxy \
    && echo "Acquire::BrokenProxy true;" >> /etc/apt/apt.conf.d/99fixbadproxy \
    && apt-get update -o Acquire::CompressionTypes::Order::=gz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get update -y

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev \
    curl gnupg2 apt-utils default-mysql-client default-mysql-server git libcurl3-dev cmake libssl-dev pkg-config openssl imagemagick file

RUN apt-get update && \
apt-get -y install apt-transport-https \
     ca-certificates \
     software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
apt-get update && \
apt-get -y install docker-ce


# Install node from nodesource
# uncomment the next 2 lines for fix
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get update && apt-get install -y nodejs

# Global install yarn package manager
RUN apt-get update && apt-get install -y curl apt-transport-https && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn
