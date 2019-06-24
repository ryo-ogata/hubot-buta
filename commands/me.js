module.exports = {
  name: 'me',
  description: 'show username, id',
  execute(message, args) {
    message.channel.send(`Your username: ${message.author.username}\nYour ID: ${message.author.id}`);
  },
};
