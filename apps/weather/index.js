'use strict';

const express = require('express');
const app = express();
const PORT = 8080;

app.use(require('./lib/api'));

app.listen(PORT);
console.log('Running on port ' + PORT);