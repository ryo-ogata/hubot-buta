require('dotenv').config();

const dds = require('./modules/dds')
const redis = require('./modules/redis')

const userId = 1;

dds.registration()
  .then(appId => {
    const key = make_dialog_session_key(userId);
    redis.set(key, appId, 'EX', process.env.EXPIRE_SEC);
    return dds.dialogue(appId, 'tanaka', '腹へったね')
  })
  .then(data => {
    console.log(data)
  })
  .catch(e => console.log(e));

function make_dialog_session_key(userId) {
  return `d_s_${userId}`;
}
