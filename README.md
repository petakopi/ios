# README

This is my attempt to build a working iOS app for https://petakopi.my. There are still tons of things to be done, but at least there's something right now.

## Development

- Put your Mapbox public token in `.mapbox` file inside the project's directory
- Setup `~/.netrc` file with this content:

```
machine api.mapbox.com
login mapbox
password YOUR_SECRET_MAPBOX_ACCESS_TOKEN
```

## Contributing

Please open an issue first if you would like to contribute. There are couple of things that everyone can start without needing a new endpoint.

Available endpoints:
- https://petakopi.my/api/v1/coffee_shops.json
- https://petakopi.my/api/v1/coffee_shops/{slug}.json

Feel free to reach out to me if you need more but it may take time since time is very limited for me.
