# Description:
#   Call buta.
#
# Notes:
#   buta.

cron = require('cron').CronJob

module.exports = (robot) ->

  # docomo
  EXPIRE_SEC=180

  request = require 'request'
  redis = require('redis')
  url = require("url")
  require('dotenv').config();

  # https://github.com/NodeRedis/node_redis
  rtg   = url.parse(process.env.REDISTOGO_URL)
  client = redis.createClient(rtg.port, rtg.hostname)
  if rtg.auth?.split(":")?.length > 1
    client.auth(rtg.auth.split(":")[1]);

  Array::compact = ->
    (elem for elem in this when elem?)
  Array::first ?= (n) ->
    if n? then @[0...(Math.max 0, n)] else @[0]
  Array::last ?= (n) ->
    if n? then @[(Math.max @length - n, 0)...] else @[@length - 1]

  robot.hear /(.*)/, (msg) ->
    text = msg.match[1]
    isFirst = false
    if (match_buta = /(ぶた|ブタ|豚|でぶ|デブ|buta)/.exec(text))
      text_buta = match_buta[0]
      msg.send "今#{text_buta}って言ったかこの野郎"
      isFirst = true
    key = make_dialog_session_key msg
    new Promise((resolve, reject) =>
      log_ "key=#{key}"
      client.get key, (err, reply) ->
        log_ "11 err=#{err}, reply=#{reply}"
        if isFirst or reply
          data =
            apikey: process.env.SMALLTALK_API_KEY
            query: text
          dataString = [
            "apikey=#{process.env.SMALLTALK_API_KEY}"
            "query=#{text}"
          ].join('&')
          log_ "21 url=#{process.env.SMALLTALK_API_URL}, data=#{JSON.stringify(data)}"
          robot.http(process.env.SMALLTALK_API_URL)
            .header('Content-Type', 'application/x-www-form-urlencoded')
            .post(dataString) (err, response, body) ->
              log_ "22 err=#{err}, response=#{response}, body=#{body}"
              json = JSON.parse body
              if json?.status == 0
                resolve(json.results[0].reply)
              else
                reject(json.message)
    )
    .then((reply) =>
      msg.send reply
      client.set key, reply, 'EX', EXPIRE_SEC
    )
    .catch((err) => { })

  make_dialog_session_key = (msg) ->
    "d_s_#{msg.envelope.user.id}"

  log_ = (obj) ->
    robot.logger.error obj

  robot.hear /(修造|しゅうぞう|shuzo|shuuzo)/, (msg) ->
    msgs = [
        '何を言われてもイライラしなーい'
        '予想外の人生になっても、そのとき、幸せだったらいいんじゃないかな'
        '真剣だからこそ、ぶつかる壁がある'
        'お醤油ベースのお吸い物にあんこ。非常識の中に常識あり'
        '苦しいか？ 修造！笑え！'
        '真剣に考えても、深刻になるな！'
        '崖っぷちありがとう！最高だ！'
        'そうだ、僕は、心から本当にテニスが大好きなんだ！'
        'いま　ここ　修造'
        '自分を好きになれ！'
        '反省はしろ！後悔はするな！'
    ]
    msg.send msg.random msgs
