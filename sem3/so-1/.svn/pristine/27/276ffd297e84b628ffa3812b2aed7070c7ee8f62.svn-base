set -euo pipefail
url=$(curl -s "https://random.imagecdn.app/v1/image?width=400&height=150")
curl -s "$url" | catimg -
curl -s https://api.chucknorris.io/jokes/random | jq '.value'
