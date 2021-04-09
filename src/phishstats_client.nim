# Import libraries
import os
import json
import httpclient
import db_sqlite
import strutils

# Global Variables, definitions
type
  Config = object
    base_url: string
    searches: JsonNode
    keywords: JsonNode
    db_file: string
    api_timeout: int
    debug: bool
#endtype

var configuration: Config
var db: DbConn
var client: HTTPClient

#######################################################################################################################

#
# bool isKnown(search, json_data)
#
# true  json_data for search already known
# false entry not found
#
proc isKnown(search: JsonNode; json_data: JsonNode): bool =
  var value = db.getValue(sql"SELECT * FROM phishstats WHERE search = ? AND phishing = ?",
      search, json_data)
  if value == "":
    return false
  return true
#endproc


#
# addPhishing(search, json_data)
#
# add a phishing entry to the db
#
proc addPhishing(search: JsonNode; json_data: JsonNode) =
  db.exec(sql"BEGIN")
  db.exec(sql"INSERT INTO phishstats VALUES ( ? , ? )", search, json_data)
  db.exec(sql"COMMIT")
#endproc


#
# lookup(keywords, json_data)
#
# lookup the db vs a phishing entry
# add the phishing if it's unknown yet
#
proc lookup(keywords: JsonNode; json_data: JsonNode) =
  for k in keywords:
    if configuration.debug:
      echo "  🔎 Looking for " , k.getStr , " in search results"
    for j in json_data:
      if contains(toUpperAscii($j),toUpperAscii(k.getStr)) == true:
        if isKnown(k, j) == false:
          echo "    ⚠️ [NEW] ", k, " in ", j
          addPhishing(k, j)
        elif configuration.debug:
          echo "    ⚠️ [OLD] ", k, " in ", j
#endproc


#
# readConfig(file_name)
#
# read the config file
#
proc readConfig(arg_file_name: string) =
  var file_descriptor: File 
  var file_name: string
  var config: string
  var jconfig: JsonNode

  # Open the configuration file
  if arg_file_name=="":
    #echo "Using default configuration file"
    file_name="phishstats.config"
  else:
    file_name=arg_file_name
  
  #echo "Using configuration from file:" & file_name
  try:
    file_descriptor = open(file_name, fmRead)
    config = file_descriptor.readAll()
  except:
    echo "Can't open or read configuration file (",file_name,")... Error detail: ", getCurrentExceptionMsg()
    quit(QuitFailure)

  file_descriptor.close()

  # Parse configuration content
  try:
    jconfig = parseJson(config)
    configuration = to(jconfig, Config)
  except:
    echo "Can't parse configuration file... Error detail: ", getCurrentExceptionMsg()
    quit(QuitFailure)

  if configuration.debug:
    echo "📔 base_url:", configuration.base_url
    echo "📔 db_file:", configuration.db_file
    echo "📔 searches:", configuration.searches
    echo "📔 keywords:", configuration.keywords
    echo "📔 api_timeout:", configuration.api_timeout, "s"
#endproc


#
# finalize()
#
# terminate connexions, cleanup...
#
proc finalize() =
  db.close()
  client.close()
  if configuration.debug:
    echo "\n🔚"
#endproc


#
# init()
#
# Initialize the environment, networking, database...
#
proc init() =

  # Do we have a path to the config file or resort to default ?
  if paramCount() >= 1:
    if paramStr(1) ==  "-h" or paramStr(1) == "--help":
      echo "Usage: phishstats_client [config file]"
      quit(QuitSuccess)

    readConfig(paramStr(1))
  else:
    readConfig("")

  try:
    db = open(configuration.db_file, "", "", "")
    db.exec(sql"""CREATE TABLE IF NOT EXISTS phishstats (search text, phishing text)""")
  except:
    dbError(db)
  
  client = newHttpClient(timeout = configuration.api_timeout * 1000)
#endproc


#
# goPhishing()
#
# iterate through searches, look for keywords in results
#
proc goPhishing() =
  var phishstats_results_json: JsonNode
  var phishstats_results_raw: string

  for search in configuration.searches:
    if configuration.debug:
      echo "\n🎣 Phishing for " & search.getStr

    try:
      phishstats_results_raw = client.getContent(configuration.base_url & search.getStr)
    except:
      echo "Error when requesting phishstats network API for search:" , search.getStr
      continue

    phishstats_results_json = parseJson(phishstats_results_raw)
    lookup(configuration.keywords, phishstats_results_json)
#endproc


#
# main()
#
#
when isMainModule:
  init()
  goPhishing()
  finalize()
#endproc