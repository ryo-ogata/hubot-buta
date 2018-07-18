# Description:
#   Call buta.
#
# Notes:
#   buta.

cron = require('cron').CronJob

module.exports = (robot) ->

  # docomo
  EXPIRE_SEC=180
  DDS_API_KEY = process.env.DDS_API_KEY
  DDS_REGISTRATION_URL = process.env.DDS_REGISTRATION_URL
  DDS_DIALOGUE_URL = process.env.DDS_DIALOGUE_URL
  REDIS_URL = process.env.REDISTOGO_URL

  request = require 'request'
  redis = require('redis')
  url = require("url")

  # https://github.com/NodeRedis/node_redis
  rtg   = url.parse(REDIS_URL)
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
    if (match_buta = /(ぶた|ブタ|豚|でぶ|デブ|buta)/.exec(text))
      text_buta = match_buta[0]
      msg.send "今#{text_buta}って言ったかこの野郎"
    new Promise((resolve, reject) =>
      key = make_dialog_session_key msg
      log_ "key=#{key}"
      client.get key, (err, reply) ->
        log_ "11 err=#{err}, reply=#{reply}"
        if err or !reply
          # 会話開始していなければ何もしない
          unless text_buta
            return
          # registration API
          data = JSON.stringify(
            botId: 'Chatting'
            appKind: 'buta'
          )
          log_ "11 DDS_REGISTRATION_URL=#{DDS_REGISTRATION_URL}"
          robot.http(DDS_REGISTRATION_URL)
            .header('Content-Type', 'application/json')
            .post(data) (err, response, body) ->
              log_ "12 err=#{err}, body=#{body}"
              if err
                reject(err)
              else
                json = JSON.parse body
                client.set key, json.appId, 'EX', EXPIRE_SEC
                resolve(json.appId)
        else
          resolve(reply)
    )
    .then((appId) =>
      send_dialog msg, appId
      client.set key, appId, 'EX', EXPIRE_SEC
    )
    .catch((err) => { })

  dateAdd = (date, delta) ->
    new Date date.getTime() + delta * 1000

  make_dialog_session_key = (msg) ->
    "d_s_#{msg.envelope.user.id}"

  send_dialog = (msg, appId) ->
    log_ "31 appId=#{appId}}"
    text = msg.message.text
    data = JSON.stringify(
      language: 'ja-JP'
      botId: 'Chatting'
      appId: appId
      voiceText: text
      clientData:
        option:
          nickname: msg.envelope.user.name
          nicknameY: msg.envelope.user.name
          mode: 'dialog'
          t: random_t()
    )
    log_ "32 data=#{data}"
    robot.http(DDS_DIALOGUE_URL)
      .header('Content-Type', 'application/json')
      .post(data) (err, response, body) ->
        log_ "33 body=#{body}"
        if err
          reject(err)
        else
          json = JSON.parse body
          msg.send json.systemText.expression

  random_t = () ->
    # 1-100
    r = (Math.floor(Math.random() * 100) + 1) % 3
    if r == 0
      'kansai'
    else if r == 1
      'akachan'
    else
      ''

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
