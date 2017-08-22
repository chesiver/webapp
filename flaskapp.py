from flask import Flask, flash, redirect, render_template, request, session, abort
app = Flask(__name__)
 
@app.route("/")
def index():
    return "Index!"
 
@app.route("/hello")
def hello():
    return "Hello World!"

@app.route("/bar_chart")
def getBarChart():
	return render_template("bar_chart.html")

@app.route("/data/bar_chart")
def getBarChartData():
	return open(app.root_path + "/" + "data/bar_chart.tsv", "r").read()

if __name__ == "__main__":
    app.run()
