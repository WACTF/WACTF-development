# Uploading images/README's to the Registry

Developers are encouraged to do this during development too

- how to auth
- use docker-compose push
- push the readme

You may find this project useful for pushing your `README` when pushing your image [docker-pushrm](https://github.com/christian-korneck/docker-pushrm).


# Delivery Checklist

1. Your container meets the hardening requirements here: [README-Setup.md](README-Setup.md)
2. The flag format is `WACTF{}`
3. Your documentation has the up-to-date `docker-compose` segment and working `PoC.py`

# Expected Deliverables

**Container Based**
Your Docker image is pushed to the Docker registry. The `README` for your image is the documentation provided in [README-Challenge.md](README-Challenge.md) which includes your [docker-compose](docker-compose.yml) segment.

**File Drop Based**
Your filedrop is either a standalone file, or an unencrypted `.zip`/`.7z` archive containing all files to be provided to the player. The name of the file/archive is `<category>-<tier>.<ext>` e.g. `forensics-3.zip`. Deliver your [README-Challenge.md](README-Challenge.md) file separately - do not put the `README` inside the archive. You can email or Slack your delivery to an organiser.