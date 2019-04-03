
Init

```
docker run --rm \
  -v ~/.shinysdr:/config \
  jeffersonjhunt/shindysdr init /config/my-config
```

Run

```
docker run --rm \
  -p 8100:8100 \
  -p 8101:8101 \
  -v ~/.shinysdr:/config \
  --name shinysdr \
  jeffersonjhunt/shindysdr start /config/my-config
```