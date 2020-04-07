require('dotenv').config();
const fs = require('fs');
const Discord = require('discord.js');
const prefix = '/';

const client = new Discord.Client();
client.commands = new Discord.Collection();

const commandFiles = fs.readdirSync('./commands').filter(file => file.endsWith('.js'));

for (const file of commandFiles) {
  const command = require(`./commands/${file}`);
  client.commands.set(command.name, command);
}

client.once('ready', () => {
  console.log('Ready!');
});

client.on('message', message => {
  if (!message.content.startsWith(prefix) || message.author.bot) return;

  const args = message.content.slice(prefix.length).split(/ +/);
  const commandName = args.shift().toLowerCase();

  if (commandName === 'hello') {
    message.member.voiceChannel.join().then(connection => {
      const sounds = [
        '/mp3/famima.mp3',
        '/mp3/nico-nico-ni.mp3',
        '/mp3/tuturu.mp3',
      ];
      const filename = sounds[Math.floor(Math.random() * sounds.length)];
      let path = require('path').join(__dirname, filename);
      console.log(path);
      const dispatcher = connection.playFile(path);
      dispatcher.on('error', console.error);
      dispatcher.setVolume(1);
      dispatcher.on('end', reason => {
        console.log('end');
        connection.disconnect();
      });
    }).catch(e => console.error(e));
  }
  if (commandName === 'bye') {
    let conn = client.internal.voiceConnection;
    if (conn) conn.disconnect();
  }

  //if (!client.commands.has(commandName)) return;
  //try {
  //  client.commands.get(commandName).execute(message, args);
  //}
  //catch (error) {
  //  console.error(error);
  //  message.reply('there was an error trying to execute that command!');
  //}
});

async function join(message) {
  if (message.member.voice.channel) {
    const connection = await message.member.voice.channel.join();
    return connection;
  } else {
    message.reply('You need to join a voice channel first!');
  }
  return null;
}

async function playMp3(connection, mp3File) {
  const dispatcher = connection.play(mp3File);
  dispatcher.setVolume(0.9);
  dispatcher.on('finish', () => {
    console.log('Finished playing!');
  });
  dispatcher.destroy();
}

client.login(process.env.DISCORD_CLIENT_TOKEN).catch(e => console.error(e));
