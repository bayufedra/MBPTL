from flask import Flask, request, render_template_string

app = Flask(__name__)

@app.route("/")
def home():
    name = request.args.get('name', 'World! (/?name=)')
    return render_template_string("""<html>
    <head>
        <title>MBPTL - Internal Web Service</title>
    </head>
    <body>
        <center>
            <h1><b>MBPTL - Internal Web Service</b></h1>
        </center>
        <p>Hello, %s</p>
        <p>MBPTL-13{b20c7cd75fd17802261d0725ae2eb733}</p>
    </body>
</html>
""" %name)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)