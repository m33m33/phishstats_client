# phishstats

This is the nim-lang rewrite of my python script, to check https://phishstats.info API for domains, keywords, ASN...

It keeps track of findings in a sqlite database and warn you only ONCE for each new discovery

So you can crontab this script and get notified only for new security incidents


## Usage

phishstats [full path to config file]


## Configuration file

The configuration file contains your phiststats API requests, and keywords you want to hightlight in results
```
#phishstats search patterns like (url,like,~YourDomainName~) separated by ,;,
searches: (url,like,~your.domain.com~),;,(title,like,~domain.com~)

#specific keywords to look for in results like specific@email.domain separated by ,;,
keywords: support@domain.com,;,vip@domain.com

#path to the database
db_file: /tmp/phishstats.sqlite
```

## Misc

Please do not harras or abuse phishstats network API.

<div>
<small>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></small></div>
