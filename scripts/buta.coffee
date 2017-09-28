# Description:
#   Call buta.
#
# Notes:
#   buta.

module.exports = (robot) ->

  robot.hear /(ぶた|ブタ|豚|でぶ|デブ|buta)/, (res) ->
    word = res.match[1]
    res.send "今#{word}って言ったかこの野郎"

  robot.hear /(もこ|モコ)/, (res) ->
    res.send "もこもこ"

  robot.hear /([^　、。！？ ]+)(する|した|してた|している|してる|できる)/, (res) ->
    word0 = res.match[1]
    word1 = res.match[2]
    res.send "#{word0}#{word1}フレンズなんだね！"

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
