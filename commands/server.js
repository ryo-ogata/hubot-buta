module.exports = {
  name: 'server',
  description: 'show server name.',
  execute(message, args) {
    message.channel.send(`This server's name is: ${message.guild.name}`);
  },
};
