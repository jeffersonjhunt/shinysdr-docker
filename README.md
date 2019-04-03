
Init

```
docker run --rm \
  -v ~/.shinysdr:/config \
  jjh01112358/shindysdr init /config/my-config
```

Run

```
docker run --rm \
  -p 8100:8100 \
  -p 8101:8101 \
  -v ~/.shinysdr:/config \
  --name shinysdr \
  jjh01112358/shindysdr start /config/my-config
```