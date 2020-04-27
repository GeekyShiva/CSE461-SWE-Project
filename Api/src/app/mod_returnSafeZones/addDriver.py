from flask import render_template, flash, redirect, url_for, session, g, request, Blueprint
from flask_login import login_required, login_user, logout_user, current_user
from app import app, db, login_manager
from ..forms import LoginForm, RegistrationForm
from app.mod_vote.models import Driver, 
from datetime import datetime
from sqlalchemy import and_
mod_auth = Blueprint('mod_auth', __name__)

@mod_auth.route('/register', methods=['GET', 'POST'])
def registerDriver():
	form = RegistrationForm()
	if form.validate_on_submit():
		user = User(email = form.email.data, username = form.username.data, password = form.password.data)
		db.session.add(user)
		db.session.commit()
		flash("You have succesfully registered! You may now login")
		return redirect(url_for('mod_auth.login'))
	return render_template('mod_auth/register.html',form = form, title = "Register")

@mod_auth.route('/login', methods = ['GET', 'POST'])
def login():
	form = LoginForm()
	if form.validate_on_submit():
		user = User.query.filter_by(email = form.email.data).first()
		if user is not None and user.verify_password(form.password.data):
			login_user(user)
			return redirect(url_for('mod_user.dashboard'))
		else:
			flash('Invalid email or password.')
	return render_template('mod_auth/login.html', form = form, title = 'Login')

@mod_auth.route('/logout', methods = ['GET', 'POST'])
def logout():
	logout_user()
	flash('You have been succesfully logged out.')
	return redirect(url_for('mod_auth.login'))

"""Registers a function to run before each request.The function will be called without any arguments. 
If the function returns a non-None value, it’s handled as if it was the return value from the view and further request handling is stopped"""

@app.before_request
def before_request():
	g.user = current_user
	if g.user.is_authenticated:
		g.user.last_seen = datetime.utcnow()
		db.session.add(g.user)
		db.session.commit()

"""app.context-> Binds the application only. For as long as the application is bound to the current context the flask.current_app points to that application. 
                 An application context is automatically created when a request context is pushed if necessary.
                 """
"""context_processor:Registers a template context processor function."""
@app.context_processor
def utility_processor():
	def user(user_id):
		"""filters users by user_id and returns an object of users"""
		return User.query.filter_by(user_id = user_id).first()
	return dict(user = user)

@app.context_processor
def DriverAllocation():
	def checkClosest(pid):
		ans = 1
		if g.user.is_authenticated:
			if driverAllocated == 0:
				"""Votetype 1-> Upvote"""
					nextDriver = user
			else : 
	return dict(driverAllocated = driverAllocated)