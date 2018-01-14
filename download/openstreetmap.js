const axios = require('axios');
const fs = require('fs');
const mkdirp = require('mkdirp-promise');
const config = require('../../pelias.json');
const promisify = require('util').promisify;

(async () => {
  const file = `${config.imports.openstreetmap.country.toLowerCase()}-latest.osm.pbf`;
  const dp = config.imports.openstreetmap.datapath;
  await mkdirp(dp);

  (await axios({
    method: 'get',
    url: `http://download.geofabrik.de/europe/${file}`,
    responseType: 'stream',
  })).data.pipe(fs.createWriteStream(`${dp}/${file}`));

  config.imports.openstreetmap.imports[0].filename = file;
  await promisify(fs.writeFile)('../pelias.json', JSON.stringify(config));
})();
