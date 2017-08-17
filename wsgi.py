from flask import Flask, flash, redirect, render_template, request, session, abort
application = Flask(__name__)
 
@application.route("/")
def index():
    return "Index!"
 
@application.route("/hello")
def hello():
    return "Hello World!"
 
@application.route("/members")
def members():
    return "Members"
 
@application.route("/members/<string:name>/")
def getMember(name):
    return render_template(
        'test.html',name=name)
 
if __name__ == "__main__":
    application.run()
