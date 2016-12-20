# Description:
#   Call buta.
#
# Notes:
#   buta.

module.exports = (robot) ->

  robot.hear /(ぶた|ブタ|豚|でぶ|デブ|buta)/, (res) ->
    word = res.match[1]
    res.send "今#{word}って言ったかこの野郎"

