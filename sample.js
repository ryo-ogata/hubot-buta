require('dotenv').config();

const dds = require('./modules/dds')
const { redis, getAsync } = require('./modules/redis')

async function getText(userId, username, inputText) {
  const key = make_dialog_session_key(userId);
  const text = getAsync(key)
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

function make_dialog_session_key(userId) {
  return `d_s_${userId}`;
}

getText(1, 'A', 'ぶた').then(text => console.log(text));
