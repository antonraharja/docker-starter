docker-starter
==============

Item            | Info
--------------- | ---------------
Project update  | 250416
Project version | 1.1
Laravel Starter | 1.2.2

This project is about docker for Laravel Starter.

Visit [Laravel Starter](https://github.com/antonraharja/laravel-starter) for more information.


## Install & Usage

First, create `.env` by copying from `.env.example`:

```
cp .env.example .env
```

Edit `.env` file, change DB password and admin password at least.

```
vi .env
```

Next, to install and then use it run this:

```
docker compose up
```


## Build

If you need to build your own image edit the image name in `.env`

For example, set `DOCKER_IMAGE_LARAVEL_STARTER="anyusername/anyimagename:anytag"` in `.env`, and then build it:

```
docker compose build
```


## Maintainer

- Anton Raharja <araharja@protonmail.com>
