import requests, json, os
tilele=210_321_300
token="AD1QG78kk28SKHLtVSBVIZ8"
tile=2103213002120
for t in range(4):
    for u in range(4):
        for v in range(4):
            tile=f"{tilele}{t}{u}{v}"
            print("\b.")
            if os.path.isfile(f"{tile}.json"):
                print("ja vi esse")
            else:
                resp=requests.get(f"https://xyz.api.here.com/hub/spaces/8pa31oKn/tile/quadkey/{tile}?margin=2&access_token={token}")
                with open(f"{tile}.json", "w+") as fu:
                    fu.write(json.dumps(resp.json()))
