curl -X POST -vv http://0.0.0.0:3000/auth/session -d "{\"username\":\"$1\",\"password\":\"$2\"}" -c cookie
