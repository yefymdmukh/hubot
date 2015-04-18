class Hook
  constructor: (opts) ->
    @response = opts.response
    @robot    = opts.robot
    @listener = opts.listener
    @message  = opts.message
    @response ||= new @robot.Response(@robot, @message)

    @reply    = opts.reply # A string response that is being sent if
                           # this hook is a reply hook

    @hooks    = opts.hooks
    @callback = opts.callback
    @nextHook = -1

  run: ->
    @nextHook += 1
    hook = @hooks[@nextHook]
    if hook?
      hook(@)
    else
      @callback()

  finish: =>
    if @reply?
      # We're processing a reply, not a listen or receive. The message has
      # been processed, so it's too late to finish() it. By not calling
      # @run() or @callback() we end processing and do not send the reply.
    else
      @message.finish()
      @callback()

  next: =>
    @run()

module.exports = {
  Hook
}
