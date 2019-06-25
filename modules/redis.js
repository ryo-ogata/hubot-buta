const url = require('url');
const rtg = url.parse(process.env.REDISTOGO_URL);
const redis = require('redis').createClient(rtg.port, rtg.hostname);
if (((ref = rtg.auth) != null ? (ref1 = ref.split(":")) != null ? ref1.length : void 0 : void 0) > 1) {
  redis.auth(rtg.auth.split(":")[1]);
}

module.exports = redis;
