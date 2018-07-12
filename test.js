
const { parse } = require('./grammar.js');
const fs = require('fs');

const file = fs.readFileSync('./example.adon', 'utf8');

console.log(
	JSON.stringify(parse(file), null, 2)
);