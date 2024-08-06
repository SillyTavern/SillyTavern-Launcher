const { getVersion } = require('./util.js');

getVersion().then(version => {
    console.log(JSON.stringify(version));
}).catch(err => {
    console.error('Error getting version:', err);
});
