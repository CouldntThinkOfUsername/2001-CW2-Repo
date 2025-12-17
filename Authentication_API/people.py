import requests
from flask import abort, make_response

BASE_URL = "https://web.socem.plymouth.ac.uk/COMP2001/auth/api/users"

def read_all(username=None):
    """
    Responds to GET /people
    Fetches the list of all users from the external Plymouth API.
    """
    try:
        response = requests.get(BASE_URL)
        
        if response.status_code == 200:
            users_list = response.json()
            
            if username:
                return [user for user in users_list if user.get('username') == username]
            
            return users_list
        else:
            return []
    except Exception as e:
        print(f"Error connecting to Plymouth API: {e}")
        return []

def read_one(userId):
    """
    Responds to GET /people/{userId}
    Fetches a specific user by their ID from the external API.
    """
    url = f"{BASE_URL}/{userId}"
    
    response = requests.get(url)
    
    if response.status_code == 200:
        return response.json()
    else:
        abort(404, f"Person with ID {userId} not found")

def create(person):
    """
    Responds to POST /people
    Sends your JSON data to the Plymouth API to verify/create the user.
    """
    headers = {"Content-Type": "application/json"}
    
    response = requests.post(BASE_URL, json=person, headers=headers)
    
    if response.status_code in [200, 201]:
        return response.json(), 201
    else:
        abort(response.status_code, f"External API Error: {response.text}")

def update(userId, person):
    """
    Responds to PUT /people/{userId}
    Updates a user record via the external API.
    """
    url = f"{BASE_URL}/{userId}"
    headers = {"Content-Type": "application/json"}
    
    response = requests.put(url, json=person, headers=headers)
    
    if response.status_code == 200:
        return response.json()
    elif response.status_code == 404:
        abort(404, f"Person with ID {userId} not found")
    else:
        abort(response.status_code, "Update failed")

def delete(userId):
    """
    Responds to DELETE /people/{userId}
    """
    url = f"{BASE_URL}/{userId}"
    
    response = requests.delete(url)
    
    if response.status_code in [200, 204]:
        return make_response(f"Person {userId} deleted", 204)
    else:
        abort(404, f"Delete failed or ID {userId} not found")