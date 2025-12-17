from config import db
from flask import make_response, abort
from models import User, users_schema, user_schema

def read_all():
    users = User.query.all()
    return users_schema.dump(users)

def read_one(user_id):
    user = User.query.filter(User.user_id == user_id).one_or_none()
    if user is not None:
        return user_schema.dump(user)
    else:
        abort(404, f"User {user_id} not found")