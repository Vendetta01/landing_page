from flask import Flask, render_template
import docker


app = Flask(__name__)

# TODO: make navbar slide to right on button click


@app.route("/")
@app.route("/<page_name>")
def show_landing_page(page_name="/"):
    pages = get_container_urls("VIRTUAL_HOST")
    selected_page = None
    if page_name:
        for page in pages:
            if page["name"] == page_name:
                selected_page = page
                page["active"] = True
            else:
                page["active"] = False

    return render_template("index.html", pages=pages, selected_page=selected_page)


def get_container_urls(env_key):
    client = docker.from_env()
    container_urls = []

    for container in client.containers.list():
        name = container.attrs["Name"][1:]
        for env_var in container.attrs["Config"].get("Env", []):
            _env_key, _env_val = env_var.split("=", 1)
            if _env_key == env_key:
                container_urls.append({"name": name, "url": _env_val})

    return container_urls


if __name__ == "__main__":
    app.run()
