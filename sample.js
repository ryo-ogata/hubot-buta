require('dotenv').config();

const dds = require('./modules/dds');
const { redis, getAsync } = require('./modules/redis');
const tts = require('./modules/tts');
const uuidv4 = require('uuid/v4');

async function getText(userId, username, inputText) {
  const key = `d_s_${userId}`;
  return await getAsync(key)
    .then(appId => {
      if (appId) {
        console.log('cacheにあるappIdをつかいます');
        return appId;
      }
      console.log('APIでappIdを取得します');
      return dds.registration();
    })
    .then(appId => {
      redis.set(key, appId, 'EX', process.env.EXPIRE_SEC);
      return dds.dialogue(appId, username, inputText)
        .then(data => {
          console.log(data);
          return data;
        })
    })
    .catch(e => console.log(e));
}

getText(1, 'A', '英語わかる')
  .then(text => {
    return {
      text: text,
      outputFile: tts(text, `./mp3/${uuidv4()}.mp3`).catch(e => console.log(e))
    };
  })
  .then(a => console.log(a))
  .catch(text => console.log(text));

