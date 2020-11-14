# Scoreboard 

FYI: One significant change we have made to Mellivora is that categories and challenges are ordered by their prefixed number rather than point value.

## Add a challenge
Go: `Manage -> Challenges -> Add challenge`.

1. Give it a title, prefixed by the challenge tier number (e.g. `0. This is the tier zero challenge`). Copy/paste the description from the challenge doco. Make sure to add the expected URL or filedrop location for this challenge. You can do this like so:

	* "Filedrop name: Forensics-2.txt" The name of the filedrop here should match exactly as it will do in the archive (i.e. the name it was delivered as).

	* "http://web-0" The DNS name for any docker based challenge will the the name from the `docker-compose` file which should be the category and the tier plus the port number it's exposing (e.g. `misc-3:1337`). If the challenge is a web challenge it should be prefixed with `http://`.


2. Paste in the complete flag including the `WACTF{` bit

3. Set the points value for the challenge based on what tier it is:

	* T0: 10 – 50 (you can decide exactly what point value this is)
	* T1: 100
	* T2: 150
	* T3: 200
	* T4: 250
	* T5: 250

4. You can leave the other options as their default value. When you save you'll be taken to the `Manage` page where you can edit some other values. You probably don't want to touch any though.
