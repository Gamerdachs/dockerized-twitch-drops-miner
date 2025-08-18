# Dockerized Twitch Drops Miner

This project provides a Dockerized version of the Twitch Drops Miner application by [DevilXD](https://github.com/DevilXD/TwitchDropsMiner). It allows you to run the Twitch Drops Miner in a containerized environment, making it easy to deploy and manage.

## How it Works

The Docker image is built based on the [`jlesage/baseimage-gui`](https://hub.docker.com/r/jlesage/baseimage-gui) which provides a web-based GUI for the application. The workflow automatically fetches the latest pre-release of Twitch Drops Miner, builds the Docker image, and pushes it to Docker Hub.

## Building the Docker Image

To build the Docker image locally, navigate to the root of this project and run the following command:

```bash
docker build . --build-arg APP_VERSION_ARG=<ASSET_UPDATED_AT> --tag gamerdachs/dockerized-twitch-drops-miner:latest
```

Replace `<ASSET_UPDATED_AT>` with the actual `updated_at` timestamp of the latest Twitch Drops Miner pre-release asset. You can find this by checking the GitHub API for [DevilXD/TwitchDropsMiner releases](https://api.github.com/repos/DevilXD/TwitchDropsMiner/releases).

## Running the Docker Container

To run the Docker container using `docker compose`, create a `compose.yaml` file in your project directory with the following content:

```yaml
services:
  twitch-drops-miner:
    image: gamerdachs/dockerized-twitch-drops-miner:latest
    container_name: twitch-drops-miner
    ports:
      - "5800:5800"
    volumes:
      - /path/to/your/config:/config:rw
    restart: unless-stopped
```

Replace `/path/to/your/config` with the actual path on your host machine where you want to store the Twitch Drops Miner's configuration and cookies. This ensures persistence across container restarts.

Once you have created the `compose.yaml` file, navigate to the directory containing the file in your terminal and run the following command:

```bash
docker compose up -d
```

*   `docker compose up -d`: This command starts the `twitch-drops-miner` service in detached mode (in the background).
*   `ports: - "5800:5800"`: This maps port 5800 of your host to port 5800 inside the container. This is the port where the web-based GUI will be accessible.
*   `volumes: - /path/to/your/config:/config:rw`: This mounts a local directory on your host machine to the `/config` directory inside the container. This is where the Twitch Drops Miner's configuration and cookies will be stored, ensuring persistence across container restarts.
*   `restart: unless-stopped`: This ensures the container will restart automatically unless it is explicitly stopped.

## Accessing the Application

Once the container is running, you can access the Twitch Drops Miner web-based GUI through your web browser.

Open your web browser and navigate to:

```
http://localhost:5800
```

If you are running Docker on a remote server or a virtual machine, replace `localhost` with the IP address or hostname of that server/VM.

## Contributing

Feel free to contribute to this project by opening issues or submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
