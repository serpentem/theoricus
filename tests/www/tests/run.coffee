wd = require 'wd'
fsu = require 'fs-util'
path = require 'path'
browsers = require './utils/browsers'

files = fsu.find (path.join __dirname, 'tests'), /\.coffee$/m

exports.test = ( name, conf, base_url, mark_as_passed, timeout )->

  title =  "[#{do name.toUpperCase}]"
  describe title, ->

    for file in files
      for browser_name, browser_conf of browsers

        # when testing local, ignores browsers that haven't the local prop set
        if name is 'local' 
          continue if not browser_conf.local

          browser_conf.platform = null
          browser_conf.version = null
        
        # otherwise, skipe local_only configs
        else if browser_conf.local_only is true
          continue

        browser_conf.name = browser_name
        browser = if conf then wd.remote conf else do wd.remote
        test = (require file).test
        test browser, browser_conf, base_url, timeout, mark_as_passed