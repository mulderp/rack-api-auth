curl -X DELETE -vv http://0.0.0.0:3000/auth/session -b "rack.session=$1" -c cookie
