#!/usr/bin/env python3
"""Test WordPress authentication"""

import requests
import base64

WORDPRESS_URL = "https://gloven.org"
WORDPRESS_USER = "admin"
# Try different password formats
PASSWORDS = [
    "24oSl Vi5A Rio3 zJeT 7BGX LnIE",  # No space after 2
    "2 4oSl Vi5A Rio3 zJeT 7BGX LnIE",  # Space after 2
]

for pwd in PASSWORDS:
    app_password = pwd.replace(' ', '')
    credentials = f"{WORDPRESS_USER}:{app_password}"
    token = base64.b64encode(credentials.encode()).decode('utf-8')
    headers = {
        'Authorization': f'Basic {token}',
        'Content-Type': 'application/json'
    }
    
    # Test with a simple GET request
    try:
        response = requests.get(f"{WORDPRESS_URL}/wp-json/wp/v2/users/me", headers=headers, timeout=10)
        print(f"Password format: {pwd[:10]}...")
        print(f"Status: {response.status_code}")
        if response.status_code == 200:
            print(f"✓ Authentication successful!")
            user = response.json()
            print(f"User: {user.get('name', 'N/A')}")
            print(f"Roles: {user.get('roles', [])}")
            break
        else:
            print(f"Response: {response.text[:200]}")
    except Exception as e:
        print(f"Error: {e}")
    print()

