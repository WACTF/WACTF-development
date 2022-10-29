# Challenge Documenation Example

| metadata                                  | <>                                     |
|-------------------------------------------|----------------------------------------|
| Developer Name(s)                         | Cam                                    |
| Best Contact (Slack handle / Email address) | cameron@NotHivint😢.com/C_Sto (WACTF Slack) |
| Challenge Category                        | Crypto                                 |
| Challenge Tier                            | 1                                      |
| Challenge Type                            | Both                                   |

| Player facing         | <>                                                                                                                                                        |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| Challenge Name        | Plaintext is good for hackers                                                                                                                             |
| Challenge Description | Cam got caught trying to log into the scoreboard while it was being developed, we got the packet capture. Find the password then login: `http://crypto-1` |
| Challenge Hint 1      | The website was protected by basic auth during development                                                                                                |
| Challenge Hint 2      | Check the basic auth header in one of the HTTP requests                                                                                                   |

| Admin Facing               | <>                                                                  |
|----------------------------|---------------------------------------------------------------------|
| Challenge Flag             | WACTF{lol_basic_auth_feels_kinda_bad_and_is_useless_over_plaintext} |
| Challenge Vuln             | Basic authentication header on all requests leaks flag              |
| Docker Usage Idle          | 0% CPU / 6MB RAM                                                    |
| Docker Usage Expected Peak | 20% CPU / 44MB RAM                                                  |
---

## Challenge PoC.py

Use Wireshark or other packet capture tool to view the HTTP requests.

Look at the GET request to /flag.

Observe the request headers and see a basic auth header and decode its `base64` value

Provide credentials to scoreboard server.

Get flag.