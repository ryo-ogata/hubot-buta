# Description:
#   Call buta.
#
# Notes:
#   buta.

module.exports = (robot) ->

  Array::compact = ->
    (elem for elem in this when elem?)
  Array::first ?= (n) ->
    if n? then @[0...(Math.max 0, n)] else @[0]
  Array::last ?= (n) ->
    if n? then @[(Math.max @length - n, 0)...] else @[@length - 1]

  robot.hear /(ぶた|ブタ|豚|でぶ|デブ|buta)/, (res) ->
    word = res.match[1]
    res.send "今#{word}って言ったかこの野郎"

  robot.hear /(もこ|モコ)/, (res) ->
    res.send "もこもこ"

  # robot.hear /([^　、。！？ ]+)(する|した|してた|している|してる|できる|きた)/, (res) ->
  #   word0 = res.match[1]
  #   word1 = res.match[2]
  #   res.send "#{word0}#{word1}フレンズなんだね！"

  robot.hear /(修造|しゅうぞう|shuzo|shuuzo)/, (res) ->
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
    res.send res.random msgs

  robot.hear /.*/, (msg) ->
    kuromoji = require("kuromoji")
    options = {
      dicPath: "node_modules/kuromoji/dist/dic"
    }
    kuromoji.builder(options)
      .build (err, tokenizer) ->
        # console.log msg.message.tokenized
        tokens = msg.message.tokenized.reverse()
        outs = [
          subtoken(tokens, ['形容詞'])
          subtoken(tokens, ['助動詞','動詞'])
        ]
        outs = outs
          .filter (elem) ->
            elem.length > 0
          .sort (a, b) ->
            a.length - b.length
        if outs.first()?
          msg.send "#{outs.first()}フレンズなんだね！"

  subtoken = (tokens, hitPosTypes) ->
    # counts = {}
    hasConcat = false
    isFinished = false
    hasMeishi = false
    outs = tokens.map (token) ->
      # if token.pos of counts
      #   counts[token.pos] = counts[token.pos] + 1
      # else
      #   counts[token.pos] = 1
      if isFinished is true
        null
      else if hasConcat is true and hasMeishi is true
        isFinished = true
        null
      else if token.pos in hitPosTypes
        hasConcat = true
        token.surface_form
      else if hasConcat
        hasMeishi = token.pos in ['名詞', '記号']
        token.surface_form
    outs?.compact().reverse().join('')
