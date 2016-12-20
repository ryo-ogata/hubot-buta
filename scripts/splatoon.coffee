# Description:
#   Display Splatoon Nawabari Stages.
#
# Notes:
#   no way.

request = require 'request'

module.exports = (robot) ->

  robot.hear /(nawabari)/i, (res) ->
    path = 'https://s3-ap-northeast-1.amazonaws.com/splatoon-data.nintendo.net/stages_info.json?' + parseInt((new Date)/1000)
    request path, (_, response) ->
      datas = JSON.parse response.body
      t = '# ステージ情報(ナワバリ)\n'
      for data in datas
        t = "#{t}* #{data.datetime_term_begin.substr 11}　〜 #{data.datetime_term_end.substr 11}\n"
        for stage in data.stages
          t = "#{t}    #{stage.name}"
        t = "#{t}\n"
      res.send t

  robot.hear /(choshi)/i, (res) ->
    path = 'https://s3-ap-northeast-1.amazonaws.com/splatoon-data.nintendo.net/stages_info.json?' + parseInt((new Date)/1000)
    request path, (_, response) ->
      datas = JSON.parse response.body
      t = '# チョーシランキング\n'
      for data in datas
        t = "#{t}* #{data.datetime_term_begin.substr 11}　〜 #{data.datetime_term_end.substr 11}\n"
        for rank, i in data.ranking
          t = "#{t}    #{i + 1}位 #{rank.mii_name}\n"
        t = "#{t}\n"
      res.send t
