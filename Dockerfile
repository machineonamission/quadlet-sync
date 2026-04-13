FROM alpine:latest
# Install everything we need, including util-linux for 'nsenter'
RUN apk add --no-cache webhook git rsync util-linux bash
COPY . /app
RUN chmod +x /app/*.sh

CMD ["/app/entry.sh"]