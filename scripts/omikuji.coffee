# Description:
#   Try Omikuji.
#
# Notes:
#   Omikuji.

module.exports = (robot) ->

  robot.hear /(omikuji|おみくじ)/, (res) ->
    res.send res.random [
      "大吉"
      "吉"
      "中吉"
      "小吉"
      "末吉"
      "凶"
      "大凶"
      ]
