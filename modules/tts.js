const textToSpeech = require('@google-cloud/text-to-speech');

const fs = require('fs');
const util = require('util');

async function tts(text, outputFile) {
  const client = new textToSpeech.TextToSpeechClient();

  const request = {
    input: {text: text},
    voice: {languageCode: 'ja', ssmlGender: 'FEMALE'},
    audioConfig: {audioEncoding: 'MP3'},
  };

  const [response] = await client.synthesizeSpeech(request);
  const writeFile = util.promisify(fs.writeFile);
  await writeFile(outputFile, response.audioContent, 'binary');
  console.log('Audio content written to file: output.mp3');
  return outputFile;
}

module.exports = tts;

//tts('こんにちわ', 'mp3/output.mp3')

