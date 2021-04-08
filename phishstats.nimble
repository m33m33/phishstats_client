# Package

version     = "0.9.0"
author      = "M33 (m33_nim@tok715.net)"
description = "Small app to request phishstats.info network API, and fire single alerts"
license     = "MIT"

bin         = @["phishstats_client"]
binDir      = "bin"
srcDir      = "src"

# Deps

requires "nim >= 1.0.0"
