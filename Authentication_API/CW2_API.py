#Authenticator API For comp2001 
# url = https://web.socem.plymouth.ac.uk/COMP2001/auth/api/users

#requirements:
# clear endpoint represented by swagger
# json output

from flask import render_template
import config
from models import User

app = config.connex_app
app.add_api(config.basedir / "CW2_Swagger.yaml")

@app.route("/users")
def home():
    users = User.query.limit(10).all() 
    return render_template("home.html", users=users)

@app.route("/users/<int:user_id>")
def view_user(user_id):
    user = User.query.filter(User.user_id == user_id).one_or_none()
    
    if user:
        return render_template("profile.html", user=user)
    else:
        return "User not found", 404

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)