'use strict';

const express = require('express');
const app = module.exports = express();
const weatherService = require('../services/weather');

app.get('/:zip', function (req, res) {
  var zip = req.params.zip;
  var fail = req.query.fail;
  
  var weather = weatherService.getByZip(zip, fail);

  res.send(weather);
});
