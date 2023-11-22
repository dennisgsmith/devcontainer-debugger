# we need a build argument to conditionally determine if we want to pip install debugpy
# this can be set from the cli or docker-compose.yml
ARG BUILD_ENV

FROM python:3.9
ARG BUILD_ENV
ENV PYTHONUNBUFFERED=1

RUN --mount=type=cache,target=/var/cache/apt \
	apt-get update -y && apt-get install -y python3-pip

# Install dependencies...
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache,id=pip \
	pip3 install wheel cython numpy -c requirements.txt \
	&& pip3 install -r requirements.txt \
	&& pip3 uninstall cython --yes

RUN if [ "$BUILD_ENV" = "debug" ]; then pip3 install debugpy; fi

COPY . /app/
WORKDIR /app

# Run app
CMD python3 main.py
