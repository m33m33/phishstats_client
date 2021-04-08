# Overview: phishstats_client

This app check https://phishstats.info API for domains, keywords, ASN...


It keeps track of findings in a sqlite database and warn you only ONCE for each new discovery, with an output like:

`⚠️ [NEW] <keyword> in <...result from phistats.info...>`


So you can crontab this app, and get notified only for new security incidents, data leaks...


## Usage

phishstats [full path to config file]


## Configuration file

The configuration is a JSON file, it contains your phiststats API requests, and keywords you want to hightlight in results
```
{
  // Phishstat's WS endpoint
  "base_url": "https://phishstats.info:2096/api/phishing?_where=",

  // search list collection
  "searches": [
    "(url,like,~private.mydomain.net~)",
    "(title,like,~my-secondary-domain.com~)",
    "(title,like,~mydomain~)~or(url,like,~mydomain~)",
    "(ip,eq,172.16.1.2)",
    "(asn,eq,as64512)"
  ],

  // keyword list collection
  "keywords": [
    "vip@mydomain.net",
    "192.168.0.254",
    "a_magic_token"
  ],

  // the database file name with optional path prefix
  "db_file": "phishstats.sqlite",

  // timeout (s) for phishstats WS requests
  "api_timeout": 60,

  // debug will show some diagnostics at runtime, turn off in production
  "debug": true
}
```

## Misc

Please do not abuse phishstats network API.

You are strongly advised to use this application (and phishstats services) to look for your very own datas only.

<div>
<small>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></small></div>
