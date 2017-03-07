const Nightmare = require('nightmare')
const nightmare = Nightmare({ show: true })


// Tests that "Home" is the innerHTML for the second a tag on the menu page
nightmare.goto('https://www.healthlocker.uk/')
  .click('i#open-nav')
  .screenshot('./test/acceptance_tests/screenshots/menu.png')
  .evaluate(function(){
    return document.getElementsByTagName('a')[1].innerHTML;
  })
  .end()
    .then(function (result) {
      result == "Home" ? console.log(`Test passed: ${result} received`) : console.log(`${result} received, expected "Home"`);
    })
    .catch(function (error) {
      console.error('Error:', error);
    });

    // nightmare.goto('https://www.healthlocker.uk/')
    //   .click('i#open-nav')
    //   .on('did-finish-load', function(){
    //     return nightmare.screenshot('./test/acceptance_tests/screenshots/menu.png')
    //   })
    //   .evaluate(function(){
    //     return document.getElementsByTagName('a')[1].innerHTML;
    //   })
    //   .end()
    //     .then(function (result) {
    //       result == "Home" ? console.log(`Test passed: ${result} received`) : console.log(`${result} received, expected "Home"`);
    //     })
    //     .catch(function (error) {
    //       console.error('Error:', error);
    //     });
