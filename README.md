
```
docker run --rm \
  -p 8100:8100 \
  -p 8101:8101 \
  -v ~/.shinysdr:/config \
  --name shinysdr \
  jjh/shinysdr init /config/my-config
```

```
docker run --rm \
  -p 8100:8100 \
  -p 8101:8101 \
  -v ~/.shinysdr:/config \
  --name shinysdr \
  jjh/shinysdr start /config/my-config
```
