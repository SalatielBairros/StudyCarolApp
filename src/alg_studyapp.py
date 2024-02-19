from flask import Flask

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def base():
    return 'Running!'

@app.route('/hello_world')
def hello_world():
    return "Hello World"

@app.route(f'/statusz')
def app_statusz():
    return 'ok'

@app.route(f'/healthz')
def app_healthz():
    return 'ok'

def main():
    """Runs from command prompt
    """
    if __name__ == "__main__":
        app.run(debug=True, host='0.0.0.0')

main()
