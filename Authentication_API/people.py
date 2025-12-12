from flask import abort, make_response

NEXT_ID = 4
PEOPLE = {
    1: {
        "userId": 1,
        "fname": "Grace",
        "lname": "Hopper",
        "username": "ghopper",
        "email": "grace@plymouth.ac.uk",     
        "password": "ISAD123!",              
        "dob": "1906-12-09",
        "user_role": "user"
    },
    2: {
        "userId": 2,
        "fname": "Tim",
        "lname": "Berners-Lee",
        "username": "timbl",
        "email": "tim@plymouth.ac.uk",       
        "password": "COMP2001!",             
        "dob": "1955-06-08",
        "user_role": "user"
    },
    3: {
        "userId": 3,
        "fname": "Ada",
        "lname": "Lovelace",
        "username": "ada_love",
        "email": "ada@plymouth.ac.uk",       
        "password": "insecurePassword",      
        "dob": "1815-12-10",
        "user_role": "user"
    },
}

def read_all(username=None):
    """
    Responds to GET /people
    If 'username' query param is present, filter by it.
    """
    people_list = list(PEOPLE.values())
    
    if username:
        matches = [p for p in people_list if p['username'] == username]
        return matches
        
    return people_list

def create(person):
    """
    Responds to POST /people
    """
    global NEXT_ID
    
    username = person.get("username")
    email = person.get("email")
    
    existing_usernames = [p['username'] for p in PEOPLE.values()]
    existing_emails = [p['email'] for p in PEOPLE.values()]
    
    if username in existing_usernames:
         abort(406, f"User with username {username} already exists")
    
    if email in existing_emails:
         abort(406, f"User with email {email} already exists")

     
    new_id = NEXT_ID
    NEXT_ID += 1
    
    person["userId"] = new_id
    PEOPLE[new_id] = person
    
    return PEOPLE[new_id], 201

def read_one(userId):
    """
    Responds to GET /people/{userId}
    """
    if userId in PEOPLE:
        return PEOPLE[userId]
    else:
        abort(404, f"Person with ID {userId} not found")

def update(userId, person):
    """
    Responds to PUT /people/{userId}
    """
    if userId in PEOPLE:
        existing_person = PEOPLE[userId]
        
        existing_person["fname"] = person.get("fname", existing_person["fname"])
        existing_person["lname"] = person.get("lname", existing_person["lname"])
        existing_person["email"] = person.get("email", existing_person["email"])
        existing_person["dob"] = person.get("dob", existing_person["dob"])
        existing_person["user_role"] = person.get("user_role", existing_person["user_role"])
        existing_person["password"] = person.get("password", existing_person.get("password"))
        
        PEOPLE[userId] = existing_person
        return existing_person
    else:
        abort(404, f"Person with ID {userId} not found")

def delete(userId):
    """
    Responds to DELETE /people/{userId}
    """
    if userId in PEOPLE:
        del PEOPLE[userId]
        return make_response(
            f"Person with ID {userId} successfully deleted", 200
        )
    else:
        abort(404, f"Person with ID {userId} not found")