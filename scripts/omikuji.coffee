# Description:
#   Try Omikuji.
#
# Notes:
#   Omikuji.

module.exports = (robot) ->

  robot.hear /おみくじ/, (res) ->
    res.send msg.random [
      "大吉"
      "吉"
      "中吉"
      "小吉"
      "末吉"
      "凶"
      "大凶"
      ]
