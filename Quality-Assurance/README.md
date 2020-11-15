# Quality Assurance 101
0. Ensure [Hackers (1995)](https://www.imdb.com/title/tt0113243/) is playing on a media device near to you
1. Check that documentation is complete and using the latest revision: [README-Challenge.md](../README-Challenge.md)
2. Is the flag the correct format: [README-Setup.md#flag-format](../README-Setup.md#flag-format)
3. Ensure the deliverable meets these requirements: [README-Delivery.md#delivery-checklist](../README-Delivery.md#delivery-checklist)
4. Ensure the challenge is solvable as expected without any "mucking around" to get it working
5. Can it broken badly in some other way?
6. Does it fit the tier that it's meant for: [README.md#challenge-difficulty](../README.md#challenge-difficulty)

## Container Specific
1. The container meets these requirements: [README-Setup.md#your-container](../README-Setup.md#your-container)
2. Ensure the `docker-compose` file has been updated to reflect the resource `reservations` and `limits` in line with the challenge's documentation

## Filedrop Specific
1. Does the filedrop name and format meet the requirements: [README-Delivery.md#file-drop-based](../README-Delivery.md#file-drop-based)

# Challenge needs updating?
1. Reply to the issue indicating challenge needs work with any updates (or contact them some other way - issue is probably easier)
2. (optional) if dev isn't on git every day, let them know there is changes/feedback

# Challenge is ready for the scoreboard
1. Copy challenge into 2020 repo in the correct folder (`ChallengeFiles` for Docker based, `FileDrop` for filedrop) [2020](https://github.com/wactf-org/2020-prod)
2. Update the [core compose yml file](https://github.com/WACTF-org/2020-prod/blob/master/ChallengeFiles/docker-compose.yaml) (unless it's a filedrop, then dont?)
3. Put the challenge readme and solvers into the relevant folder in `ChallengeDocumentation`
4. Make the challenge exist on the scoreboard: [README-Scoreboard.md](README-Scoreboard.md)
5. Update relevant spot in progress table in [README.md](https://github.com/WACTF-org/2020-prod/blob/master/README.md) to `R`
6. Celebrate by starting [Hackers (1995)](https://www.imdb.com/title/tt0113243/) from the beginning, and watching it all the way through again
