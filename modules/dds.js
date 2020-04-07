const axios = require('axios').create({
  timeout: 10000, // default is `0` (no timeout)
});

async function registration() {
  const response = await axios.post(process.env.DDS_REGISTRATION_URL, {
    botId: 'Chatting',
    appKind: 'buta'
  })
  return response.data.appId;
}

async function dialogue(appId, nickname, text) {
  const response = await axios.post(process.env.DDS_DIALOGUE_URL, {
    language: 'ja-JP',
    botId: 'Chatting',
    appId: appId,
    voiceText: text,
    clientData: {
      option: {
        nickname: nickname,
        nicknameY: nickname,
        mode: 'dialog',
        t: random_t()
      }
    }
  })
  return response.data.systemText.expression;
}

function random_t() {
  let r = (Math.floor(Math.random() * 100) + 1) % 5;
  if (r == 0 || r == 1) {
    return 'kansai';
  } else if (r == 2 || r == 3) {
    return 'akachan';
  }
  return '';
}

module.exports = {
  registration: registration,
  dialogue: dialogue
}
