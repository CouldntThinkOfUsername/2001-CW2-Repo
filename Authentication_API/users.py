from flask import make_response, abort
from config import db
from models import User, users_schema, user_schema

def read_all():
    """
    Responds to GET /api/users
    """
    users = User.query.all()
    return users_schema.dump(users)

def read_one(user_id):
    """
    Responds to GET /api/users/{user_id}
    """
    user = User.query.filter(User.user_id == user_id).one_or_none()
    
    if user is not None:
        return user_schema.dump(user)
    else:
        abort(404, f"User {user_id} not found")

def create(body):
    """
    Responds to POST /api/users
    """
    try:
        new_user = user_schema.load(body, session=db.session)
        
        db.session.add(new_user)
        db.session.commit()
        
        return user_schema.dump(new_user), 201
    except Exception as e:
        abort(400, f"Error creating user: {str(e)}")

def update(user_id, body):
    """
    Responds to PUT /api/users/{user_id}
    """
    existing_user = User.query.filter(User.user_id == user_id).one_or_none()

    if existing_user:
        try:
            update_data = user_schema.load(body, session=db.session)
            
            existing_user.first_name = update_data.first_name
            existing_user.last_name = update_data.last_name
            existing_user.date_of_birth = update_data.date_of_birth
            existing_user.user_role = update_data.user_role
            
            db.session.merge(existing_user)
            db.session.commit()
            return user_schema.dump(existing_user), 200
        except Exception as e:
            abort(400, f"Error updating user: {str(e)}")
    else:
        abort(404, f"User with id: {user_id} not found")

def delete(user_id):
    """
    Responds to DELETE /api/users/{user_id}
    """
    existing_user = User.query.filter(User.user_id == user_id).one_or_none()

    if existing_user:
        db.session.delete(existing_user)
        db.session.commit()
        return make_response(f"User {user_id} successfully deleted", 204)
    else:
        abort(404, f"User with id: {user_id} not found")