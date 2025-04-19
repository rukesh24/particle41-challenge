import datetime
import os
from flask import Flask, request, jsonify

app = Flask(__name__)

# Define a function to get the current UTC time in ISO format
def get_current_timestamp():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()

# Define a function to get the visitor's IP address
def get_visitor_ip():
    # Use X-Forwarded-For if behind a proxy, otherwise use remote_addr
    if "X-Forwarded-For" in request.headers:
        return request.headers.getlist("X-Forwarded-For")[0].split(',')[0].strip()
    else:
        return request.remote_addr

@app.route('/')
def get_time_ip_service():
    timestamp = get_current_timestamp()
    ip_address = get_visitor_ip()

    # Create the JSON response data
    data = {
        "timestamp": timestamp,
        "ip": ip_address
    }
    # Return the data as a JSON response
    return jsonify(data)

if __name__ == '__main__':
    # Get port from environment variable or default to 5000
    port = int(os.environ.get('PORT', 5000))
    # Run on 0.0.0.0 to be accessible outside the container
    # debug=False for production/docker, set to True for local dev if needed
    app.run(debug=False, host='0.0.0.0', port=port)
