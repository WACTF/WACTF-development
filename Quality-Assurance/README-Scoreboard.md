# Scoreboard

Read this list and understand it:

1. DO NOT FORGET to put the URL/filedrop name/host+port in the challenge description
2. Categories and challenges are ordered by their **prefixed number** rather than alphabetically or by point value.
3. Kubernetes uses DNS. For e.g. challenge web-3-2 will (probably) be at `http://web-3-2` (**unless the challenge isn't running on port 80**), misc 2 on port 8080 will be `misc-2:8080` etc. etc.
4. Don't add the hints while creating a challenge. They go live as soon as you add them!

## Add a category (if required)
Go: `Manage -> Categories -> Add category`.
Give it a name prefixed with a number. The default settings should be fine but **UNCHECK** the "Exposed" checkbox.

## Add a challenge
Go: `Manage -> Challenges -> Add challenge`.

1. Give it a title prefixed by a number e.g. "1. This is the tier one challenge". This **does not** need to match the container name. For e.g. web-3-2 can be "4. the next web challenge".

2. Copy/paste the description from the challenge doco. Add the expected URL or filedrop location for this challenge like so:

a) "File drop name: Forensics-2.txt" (this should match what's in the `FileDrop` directory)

b) "[url=http://web-0]http://web-0[/url]" (don't forget the port number if it's not exposed on port 80)

c) "`exp-2:1337`"

Always use BB code to prettify links: `[url=http://hats.com]http://hats.com[/url]`.

3. Paste in the complete flag including the `WACTF{` bit

4. Set the points value for the challenge based on what tier it is:
   * T0: 10 – 50 (multiples of 5. you decide the point value based on the challenge difficulty when compared with the other T0s)
   * T1: 100
   * T2: 150
   * T3: 200
   * T4: 250
   * T5: 250

5. Leave the rest of the stuff as default, including the "Exposed" checkbox (because the category isn't exposed, we can expose the challenges). DON'T ADD THE HINTS!

6. Save that motherfucker and check that it looks good under `Manage` and isn't currenly exposed to the world under `Challenges`

## How do I find what the URL and/or port number will be?
Take a look at the docker-compose file, the DNS location will be `category-tier:exposed_port`. So exploit 3 might be `exp-3:1300`