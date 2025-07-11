from flask import Flask, request, render_template_string

app = Flask(__name__)

@app.route("/")
def home():
    name = request.args.get('name', 'World! (/?name=)')
    return render_template_string("<h1>MBPTL - Internal Web Service</h1><br><p>Hello, %s</p>" %name)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)