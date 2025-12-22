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

def create(User):
    user_id = User.get("user_id")
    existing_User = User.query.filter(User.user_id == user_id).one_or_none()

    if existing_User is None:
        new_User = users_schema.load(User, session=db.session)
        db.session.add(new_User)
        db.session.commit()
        return users_schema.dump(new_User), 201
    else:
        abort(406, f"User with id: {user_id} already exists")


def update(user_id, User):
    existing_User = User.query.filter(User.user_id == user_id).one_or_none()

    if existing_User:
        update_User = users_schema.load(User, session=db.session)
        existing_User.fname = update_User.fname
        db.session.merge(existing_User)
        db.session.commit()
        return users_schema.dump(existing_User), 201
    else:
        abort(404, f"User with id: {user_id} not found")


def delete(user_id):
    existing_User = User.query.filter(User.user_id == user_id).one_or_none()

    if existing_User:
        db.session.delete(existing_User)
        db.session.commit()
        return make_response(f"{user_id} successfully deleted", 200)
    else:
        abort(404, f"User with id: {user_id} not found")
