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
  DDS_DIALOGUE_URL = process.env.DDS_DIALOGUE_URL
  REDIS_URL = process.env.REDISTOGO_URL

  request = require 'request'
  redis = require('redis')
  url = require("url")

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

  robot.hear /(ぶた|ブタ|豚|でぶ|デブ|buta)/, (msg) ->
    # dialog session start
    key = make_dialog_session_key msg
    client.set(key, true, 'EX', EXPIRE_SEC)
    # res
    word = msg.match[1]
    msg.send "今#{word}って言ったかこの野郎"

  robot.hear /(もこ|モコ)/, (msg) ->
    msg.send "もこもこ"

  robot.hear /.*/, (msg) ->
    # 会話中ならば雑談APIを呼ぶ
    key = make_dialog_session_key msg
    client.get key, (err, reply) ->
      if reply
        send_dialog msg

  make_dialog_session_key = (msg) ->
    "d_s_#{msg.envelope.user.id}"

  send_dialog = (msg) ->
    userId = msg.envelope.user.id
    text = msg.message.text
    contextKey = "dds_ctx_#{userId}"
    savedContextValue = client.get contextKey
    savedContextValue = "" if savedContextValue?.length? <= 0

    data = JSON.stringify(
      utt: text
      nickname: msg.envelope.user.name
      context: savedContextValue
      mode: "dialog"
    )

    robot.http(DDS_DIALOGUE_URL)
      .header('Content-Type', 'application/json')
      .post(data) (err, response, body) ->
        if err
          return
        json = JSON.parse body
        msg.send json.utt
        client.set(contextKey, json.context, 'EX', EXPIRE_SEC)

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
