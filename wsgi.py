from flask import Flask, flash, redirect, render_template, request, session, abort
application = Flask(__name__)
 
@application.route("/")
def index():
    return "Index!"
 
@application.route("/hello")
def hello():
    return "Hello World!"

@application.route("/bar_chart")
def getBarChart():
	return render_template("bar_chart.html")

@application.route("/data/bar_chart")
def getBarChartData():
	print(application.root_path)
	return open(application.root_path + "/" + "data/bar_chart.tsv", "r").read()

if __name__ == "__main__":
    application.run()
