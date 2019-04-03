
```
docker run --rm \
  -p 8100:8100 \
  -p 8101:8101 \
  -v ~/.shinysdr:/config \
  --name shinysdr \
  jjh01112358/shindysdr init /config/my-config
```

```
docker run --rm \
  -p 8100:8100 \
  -p 8101:8101 \
  -v ~/.shinysdr:/config \
  --name shinysdr \
  jjh01112358/shindysdr start /config/my-config
```
