'use strict';

const owm = require('../open-weather-map');
const wu = require('../weather-underground');

module.exports = {
  getByZip: getByZip
}

function getByZip(zip, fail){
  var weather = "";

  if(fail === "true"){
    weather = wu.getByZip(zip);
  }else{
    weather = owm.getByZip(zip);
  }

  return weather;
}
