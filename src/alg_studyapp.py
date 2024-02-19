from flask import Flask

app = Flask(__name__)

@app.route('/hello_world')
def hello_world():
    return "Hello World"

def main():
    """Runs from command prompt
    """
    if __name__ == "__main__":
        app.run(debug=True, host='0.0.0.0')

main()
