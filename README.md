# Overview: phishstats_client

This app check https://phishstats.info API for domains, keywords, ASN...


It keeps track of findings in a sqlite database and warn you only ONCE for each new discovery, with an output like:

`⚠️ [NEW] <keyword> in <...result from phistats.info...>`


So you can crontab this app, and get notified only for new security incidents, data leaks...


# Usage

phishstats [full path to config file]


# Output

## When no alerts fired:

It does'nt print anything...

## When an alert is fired:

Here we have found `this-keyword` in a search result
```
    ⚠️ [NEW] "this-keyword" in {"id":12345,"url":"http://exemple.website/path/this-keyword.html","ip":null,"countrycode":null,"countryname":null,"regioncode":null,"regionname":null,"city":null,"zipcode":null,"latitude":null,"longitude":null,"asn":null,"bgp":null,"isp":null,"title":null,"date":"1970-01-01T00:00:00.000Z","date_update":"2021-03-08T00:00:00.000Z","hash":"...","score":null,"host":"exemple.website","domain":null,"tld":"website","domain_registered_n_days_ago":null,"screenshot":null,"abuse_contact":null,"ssl_issuer":null,"ssl_subject":null,"alexa_rank_host":null,"alexa_rank_domain":null,"n_times_seen_ip":null,"n_times_seen_host":null,"n_times_seen_domain":null,"http_code":null,"http_server":null,"google_safebrowsing":null,"virus_total":null,"abuse_ch_malware":null,"threat_crowd":null,"threat_crowd_subdomain_count":null,"threat_crowd_votes":null,"vulns":null,"ports":null,"os":null,"tags":null,"technology":null,"page_text":"   "}

```

## When started in debug mode:

```
📔 base_url:https://phishstats.info:2096/api/phishing?_where=
📔 db_file:phishstats.sqlite
📔 searches:["(url,like,~private.mydomain.net~)","(title,like,~my-secondary-domain.com~)","(title,like,~mydomain~)~or(url,like,~mydomain~)","(ip,eq,172.16.1.2)","(asn,eq,as64512)"]
📔 keywords:["vip@mydomain.net","192.168.0.254","a_magic_token"]
📔 api_timeout:60s

🎣 Phishing for (url,like,~private.mydomain.net~)
  🔎 Looking for vip@mydomain.net in search results
  🔎 Looking for 192.168.0.254 in search results
  🔎 Looking for a_magic_token in search results

🎣 Phishing for (title,like,~my-secondary-domain.com~)
  🔎 Looking for vip@mydomain.net in search results
  🔎 Looking for 192.168.0.254 in search results
  🔎 Looking for a_magic_token in search results

🎣 Phishing for (title,like,~mydomain~)~or(url,like,~mydomain~)
  🔎 Looking for vip@mydomain.net in search results
  🔎 Looking for 192.168.0.254 in search results
  🔎 Looking for a_magic_token in search results

🎣 Phishing for (ip,eq,172.16.1.2)
  🔎 Looking for vip@mydomain.net in search results
  🔎 Looking for 192.168.0.254 in search results
  🔎 Looking for a_magic_token in search results

🎣 Phishing for (asn,eq,as64512)
  🔎 Looking for vip@mydomain.net in search results
  🔎 Looking for 192.168.0.254 in search results
  🔎 Looking for a_magic_token in search results

🔚
```

# Configuration file

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

# Misc

Please do not abuse phishstats network API.

You are strongly advised to use this application (and phishstats services) to look for your very own datas only.

<div>
<small>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></small></div>
