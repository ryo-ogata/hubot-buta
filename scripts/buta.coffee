# Description:
#   Call buta.
#
# Notes:
#   buta.

module.exports = (robot) ->

  robot.hear /(ぶた|ブタ|豚|でぶ|デブ|buta)/, (res) ->
    res.send "今デブって言ったかこの野郎"
