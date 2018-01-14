const axios = require('axios');
const unzip = require('unzip');
const fs = require('fs');
const mkdirp = require('mkdirp-promise');
const promisify = require('util').promisify;
const config = require('../../pelias.json');

(async () => {
  const countryCode = config.imports.openaddresses.country
    .toLowerCase()
    .substr(0, 2);
  const dp = config.imports.openaddresses.datapath;
  await mkdirp(`${dp}/${countryCode}`);

  const countryParts = (await axios.get(
    'http://results.openaddresses.io/state.txt',
  )).data
    .split('\n')
    .filter(l => l.startsWith(`${countryCode}/`))
    .map(l => l.split('\t'));

  await Promise.all(
    countryParts.filter(c => !!c[8]).map(async dep => {
      (await axios({
        method: 'get',
        url: dep[8],
        responseType: 'stream',
      })).data
        .pipe(unzip.Parse())
        .on('entry', entry => {
          var fileName = entry.path;
          if (fileName.endsWith('.csv')) {
            entry.pipe(fs.createWriteStream(`${dp}/${fileName}`));
          } else {
            entry.autodrain();
          }
        });
    }),
  );

  config.imports.openaddresses.files = (await promisify(fs.readdir)(
    `${dp}/${countryCode}`,
  )).map(f => `${countryCode}/${f}`);
  await promisify(fs.writeFile)('../pelias.json', JSON.stringify(config));
})();
