import Wappalyzer from "wappalyzer";

const options = {
  debug: false,
  delay: 500,
  maxDepth: 3,
  maxUrls: 10,
  maxWait: 5000,
  recursive: true,
  userAgent: 'Wappalyzer',
};
 
const wappalyzer = new Wappalyzer('https://www.wappalyzer.com', options);
 
console.log("test");
wappalyzer.analyze()
  .then(json => {
    $("#output").html(JSON.stringify(json, null, 2));
  })
  .catch(error => {
    process.stderr.write(error + '\n');
 });

//  const options = {
//   debug: false,
//   delay: 500,
//   maxDepth: 3,
//   maxUrls: 10,
//   maxWait: 5000,
//   recursive: true,
//   userAgent: 'Wappalyzer',
// };
//  const Wappalyzer = require("wappalyzer");
//  const site = new Wappalyzer('https://www.wappalyzer.com', options);
// a =  site.analyze().then(console.log)

