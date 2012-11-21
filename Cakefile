fs     = require 'fs'
path   = require 'path'
util   = require 'util'
growl  = require 'growl'
cs     = require 'coffee-script'
stylus = require 'stylus'

config = JSON.parse fs.readFileSync('./config.json').toString()

compileCoffee = (srcPath, destDirPath) ->
    try
      output = cs.compile(fs.readFileSync srcPath, 'utf8')
    catch error
      notify "Compile #{srcPath} failed.", error
    filename = path.basename srcPath, '.coffee'
    destPath = "#{destDirPath}/#{filename}.js"
    util.log "Compile #{srcPath} to #{destPath}"
    fs.writeFileSync destPath, output, 'utf8'

compileStylus = (srcPath, destDirPath) ->
    stylus(fs.readFileSync srcPath, 'utf8').render (error, output) ->
      if error
        notify "Compile #{srcPath} failed.", error
      else
        filename = path.basename srcPath, '.styl'
        destPath = "#{destDirPath}/#{filename}.css"
        util.log "Compile #{srcPath} to #{destPath}"
        fs.writeFileSync destPath, output, 'utf8'

task 'coffeescript', 'watch and build CoffeeScript files', ->
  compile = (srcPath) ->
    compileCoffee srcPath, config.coffeescript.destination

  fs.mkdirSync config.coffeescript.destination if not fs.existsSync config.coffeescript.destination
  sources = getFiles config.coffeescript.source, '.coffee'
  sources.forEach (srcPath) ->
    compile srcPath

  watch sources, compile

task 'stylus', 'watch and build Stylus files', ->
  compile = (srcPath) ->
    compileStylus srcPath, config.stylus.destination

  fs.mkdirSync config.stylus.destination if not fs.existsSync config.stylus.destination
  sources = getFiles config.stylus.source, '.styl'
  sources.forEach (srcPath) ->
    compile srcPath

  watch sources, compile

getFiles = (dir, extension) ->
  files = fs.readdirSync dir
  result = []
  for file in files
    do (file) ->
      currentFile = dir + '/' + file
      stats = fs.statSync currentFile
      if stats.isFile() and path.extname(currentFile) is extension
        result.push currentFile
      else if stats.isDirectory()
        return result.concat getFiles(file, extension)
  return result

watch = (files, compile) ->
  util.log "Watching for changes in [#{files}]"
  for file in files then do (file) ->
    fs.watch file, (event, filename) ->
      compile file
      filename = path.basename file
      notify "#{filename} changed', 'Build complete."

notify = (title, message) ->
  options = {title:title}
  growl message, options

task 'dev', 'Watch files for changes', (options) ->
  invoke 'coffeescript'
  invoke 'stylus'