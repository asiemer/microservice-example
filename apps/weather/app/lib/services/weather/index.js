'use strict';

const owm = require('../open-weather-map');
const wu = require('../weather-underground');

module.exports = {
  getByZip: getByZip
}

function getByZip(zip, fakeFail){
  var weather = "";

  if(fakeFail === "true"){
    weather = wu.getByZip(zip);
  }else{
    weather = owm.getByZip(zip);
  }

  return weather;
}
