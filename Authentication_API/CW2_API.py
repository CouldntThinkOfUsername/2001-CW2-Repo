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

@app.route("/")
def home():
    users = User.query.limit(10).all() 
    return render_template("home.html", users=users)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)