from flask import Flask, flash, redirect, render_template, request, session, abort, url_for
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

@app.route("/heat_map")
def getHeatMap():
	return render_template("day_hour_heatmap.html")

@app.route("/data/heat_map1")
def getHeatMap1():
	return open(app.root_path + "/" + "data/heatmap_1.tsv", "r").read()

@app.route("/data/heat_map2")
def getHeatMap2():
	return open(app.root_path + "/" + "data/heatmap_2.tsv", "r").read()

@app.route("/processing/flocking_bird")
def processingFlockingBird():
	return render_template("flocking_bird.html")

@app.route("/processing/diffusion")
def processingDiffusion():
	return render_template("diffusion.html")

if __name__ == "__main__":
    app.run()