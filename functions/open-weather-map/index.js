exports.handle = function(event, context, callback){
  console.log('processing event: %j', event);
  callback(null, {
      hello: "open-weather-map"
  });
}