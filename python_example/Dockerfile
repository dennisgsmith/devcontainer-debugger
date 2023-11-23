# we need a build argument to conditionally determine if we want to pip install debugpy
# this can be set from the cli or docker-compose.yml
ARG BUILD_ENV

FROM python:3.11
ARG BUILD_ENV
ENV PYTHONUNBUFFERED=1

RUN --mount=type=cache,target=/var/cache/apt apt-get update -y

# Install dependencies...
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache,id=pip \
	python -m pip install wheel cython numpy -c requirements.txt \
	&& pip install -r requirements.txt \
	&& pip uninstall cython --yes

RUN if [ "$BUILD_ENV" = "debug" ]; then pip install debugpy; fi

COPY . /app/
WORKDIR /app

# Run app
CMD python main.py
