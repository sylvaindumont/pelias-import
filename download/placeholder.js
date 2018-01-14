const axios = require('axios');
const zlib = require('zlib');
const mkdirp = require('mkdirp-promise');
const fs = require('fs');
const promisify = require('util').promisify;
const config = require('../../pelias.json');

(async () => {
  const dp = `/data/placeholder`;
  await mkdirp(dp);

  (await axios({
    method: 'get',
    url: 'http://pelias-data.s3.amazonaws.com/placeholder/wof.extract.gz',
    responseType: 'stream',
  })).data
    .pipe(zlib.createGunzip())
    .pipe(fs.createWriteStream(`${dp}/wof.extract`));

  (await axios({
    method: 'get',
    url: 'http://pelias-data.s3.amazonaws.com/placeholder/store.sqlite3.gz',
    responseType: 'stream',
  })).data
    .pipe(zlib.createGunzip())
    .pipe(fs.createWriteStream(`${dp}/store.sqlite3`));
})();
