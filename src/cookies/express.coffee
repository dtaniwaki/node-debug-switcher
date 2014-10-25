utils = require '../utils'
assert = require 'assert'

module.exports = (key, options) ->
  options ||= {}
  secure = options.secure
  password = options.password
  env = options.env || 'NODE_DEBUG'

  assert password, 'password is required' if secure

  (req, res, next) ->
    debug = process.env[env]

    newDebug = req.cookies?[key]
    if secure
      newDebug = utils.decode64Cipher(newDebug, password)
    process.env[env] = newDebug if newDebug

    try
      next()
    catch err
      process.env[env] = debug
      throw err
    process.env[env] = debug