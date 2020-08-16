# simple example Dockerfile creating an alpine image with low-priv user and executing a non interactive command.

# Rename to 'Dockerfile'

FROM alpine:latest

# allows to not cache the index locally, keeps containers small
# https://gist.github.com/sgreben/dfeaaf20eb635d31e1151cb14ea79048
RUN apk add --no-cache

# add/del packages if necessary
#RUN apk del/add apkname

# create a new user and group
RUN adduser -S -s /bin/false -H -D myuser

# if you don't need a user with any interactivity you can do something like this instead
#RUN addgroup -S mygroup && adduser --system --shell /bin/nologin --no-create-home -G mygroup --disabled-password myuser

# all commands after this will run as myuser and not root
USER myuser

# the directory container will start in
WORKDIR /home/myuser/

# default command to run when container starts
CMD ["/bin/false"]
