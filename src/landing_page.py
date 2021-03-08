from os import getenv
from flask import Flask, render_template
import docker


app = Flask(__name__)

# TODO: make navbar slide to right on button click


@app.route("/")
@app.route("/<page_name>")
def show_landing_page(page_name="/"):
    pages = get_container_urls()
    selected_page = None
    if page_name:
        for page in pages:
            if page["name"] == page_name:
                selected_page = page
                page["active"] = True
            else:
                page["active"] = False

    return render_template("index.html", pages=pages, selected_page=selected_page)


def get_container_urls():
    client = docker.from_env()
    container_urls = []
    blacklist_names = getenv("BLACKLIST_NAMES", "").split(",")

    for container in client.containers.list():
        name = container.attrs["Name"][1:]
        container_dict = {"name": name}
        if name in blacklist_names:
            continue

        for env_var in container.attrs["Config"].get("Env", []):
            env_key, env_val = env_var.split("=", 1)
            if env_key == "VIRTUAL_HOST" and getenv("VIRTUAL_HOST") != env_val:
                container_dict["url"] = env_val
            elif env_key == "VIRTUAL_ICON":
                container_dict["icon"] = env_val
        if "url" in container_dict:
            container_urls.append(container_dict)

    return container_urls


if __name__ == "__main__":
    app.run()
