# Uploading Challenges and Documentation

The method planned originally for challenge submission was to allow developers push access to the WACTF container registry, however, due to a lack of access control tools, this method has changed.

The current method provides each developer with a GitHub repository, which is located within the [WACTF-org organisation](https://github.com/WACTF-org). 

Standard developers will have full read/write access to their own repo **only**.

Developers who are performing QA/reviewing submissions, will have full read/write access to **all** developer repositories.

The idea then, is to have developers push challenges to their own repo. This can occur right at the end of development when the challenge is ready for review, or throughout the development process.

When a developer is happy their challenge conforms to all requirements, and is ready for delivery, they can create an issue and tag a member of the reviewers team. This kicks off the review process, and changes will be made by both persons until the reviewer is happy, and the issue is labeled as "QA Complete".

At this point, the developer has completed everything that is required of them.

## Repository Structure

An example Repository, which all developers have read access to, is [challenge-template](https://github.com/WACTF-org/challenge-template).

Please use the above repository as a guide when setting up your own repository. However, a high level description of the structure is as follows:

### Repository Root
The repository root should only contain 1 file, and 1 or more folders, these are:

- File
  - `docker-compose.yml`
- Folders
  - 1 or more challenge folder roots i.e. `exploit-1`

### Challenge Folder Root

Within each challenge folder, 2 files should exist, and either 1 or 2 folders should exist. These are:

- Files
  - `Dockerfile`
  - Challenge documentation in markdown i.e.`exploit-1.md`
- Folders
  - `docker-files` which contains all source code and artifacts used in your challenge container
  - (optional) `solution` which contains the scripts or commands needed to solve the challenge

## Delivery Checklist

1. Your Dockerfile meets the hardening requirements here: [README-Setup.md](README-Setup.md)
2. The flag format is `WACTF{}`
3. You have run `docker stats` to collect your challenge's idle CPU/Memory usage and expected peak usage during the solve and have caputed these figures (rougly) in your documentation
4. Your repository conforms to the specified Repository Structure as shown above
5. If applicable, your repository has a solution script within the `solution` folder
6. You have a `docker-compose.yml` file in your repository root
7. You have run `docker-compose --build up` in the repository root, and validated all your challenges successfully start, and can be solved

## Delivery Process

See below for which steps need to be taken when delivery the two different challenge formats

### Container Based

1. Clone your developer repository: `git clone git@github.com:WACTF-org/username-challenges.git`
2. Add all files and code, remembering to conform to the Repository Structure: `cd username-challenge && cp -r ~/all_chal_files/ .`
3. Add and commit your changes: `git add --all && git commit -m "meaningful comment here"`
4. Push your changes, so that they appear within GitHub: `git push`
5. Create a GitHub issue within your respository
6. Within the issue, tag an individual reviewer via their name, i.e. `@C_Sto`. Or, tag all reviewers via `@Reviewers`
7. The QA process will then begin, with the reviewer suggesting changes and fixes which need to be made
8. Apply fixes and changes as needed, until the reviewer is satisfied
9. At this point, the reviewer will apply a "QA Complete" label to the issue, and the submission will be ready for integration into the main private repository

### File Drop Based

Your filedrop is either a standalone file, or an unencrypted `.zip`/`.7z` archive containing all files to be provided to the player. The name of the file/archive is `<category>-<tier>.<ext>` e.g. `forensics-3.zip`. Deliver your [README-Challenge.md](README-Challenge.md) file separately - do not put the `README` inside the archive. You can email or Slack your delivery to an organiser.
