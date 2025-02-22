# boonxy
[![Publish Docker image as latest](https://github.com/muller2002/boonxy/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/muller2002/boonxy/actions/workflows/docker-publish.yml)

boonxy, the Boon proxy. A docker image that proxies the Uni Bonn website and performs string replacements in the response.

## Envirionment Variables

| Env | Default | Description |
| --- | --- | --- |
| DOMAIN | uni-bonn.de | short domain under which the boonxy will be reachable (e.g. uni-boon.de) |
| DNS_RESOLVER | 1.1.1.1 | optional IP address of a local DNS resolver, by default a Cloudflare DNS server will be used |

## LICENSE

This repository is licensed under [MIT](LICENSE).

## Thanks

This repository is based on the [brukxy](https://github.com/reon04/bruxy) from people from the Bochum-Ruhr University. Thanks for the great work!
