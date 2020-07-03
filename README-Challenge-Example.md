| metadata | <> |
|--- | --- |
| Developer Name(s) | Cam |
| Best Contact Slack/Email | cameron@hivint.com/C_Sto (WACTF Slack) |
| Challenge Category | Crypto |
| Challenge Tier | 1 |
| Challenge Type | FileDrop |

| Player facing | <> |
|--- | --- |
|Challenge Name | Plaintext is good for hackers |
|Challenge Description | Cam got caught trying to log into the scoreboard while it was being developed, we got the packet capture. | 
|Challenge Hint 1 | The website was protected by basic auth during development |
|Challenge Hint 2 | Check the basic auth header in one of the HTTP requests |

| Admin Facing | <> |
|--- | --- |
|Challenge Flag| WACTF{lol_basic_auth_feels_kinda_bad_and_is_useless_over_plaintext} |
|Challenge Vuln| Basic authentication header on all requests leaks flag |
---

# docker-compose.yml

```
# Not applicable for this challenge, but by way of example:

version: '3'
services:

  exp-3:
    container_name: exp-3
    build: ./exp-3/
    image: registry.capture.tf:5000/wactf0x04/exp-3
    ports:
      - 80:2222
    deploy:
      resources:
        limits:
          cpus: '0.10'
          memory: 180M
        reservations:
          cpus: '0.05'
          memory: 10M
    cap_drop:
      - NET_RAW
```

# Challenge PoC.py

Use Wireshark or other packet capture tool to view the HTTP requests.

Look at the GET request to /flag.

Observe the request headers and see a basic auth header and decode its `base64` value

Get flag.