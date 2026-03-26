// -----------------------------------------------------------------------------
//                    JavaScript to improve accessibility
// -----------------------------------------------------------------------------

function addFocus(element) {
  element.setAttribute('tabindex', '0');
}

function setFocus(id_value) {
  document.getElementById(id_value).focus();
}

function ariaHide(element) {
  element.setAttribute('aria-hidden', 'true');
}

function setHighLevelIds(delay_ms) {
  var setHighLevelIdsCallback = setInterval(function() {
    try {
      var divHighestElement = document.querySelector('main > div');
      divHighestElement.setAttribute('id', 'div_post_nav');
      clearInterval(setHighLevelIdsCallback);
    }
    catch(e) {}
  }, delay_ms);
}

function aFocus(delay_ms) {
  // https://medium.com/@traffordDataLab/alt-text-for-dynamic-plots-in-shiny-2e24c684f187
  // Setup a call to the update function every delay_ms milliseconds
  var aFocusCallback = setInterval(function() {
    try {
      // Add focus to all <a> elements
      //https://www.digitalocean.com/community/tutorials/how-to-modify-attributes-classes-and-styles-in-the-dom
      const tabsetElement = document.getElementById('tabset');
      const aElements = tabsetElement.querySelectorAll('a');
      aElements.forEach(addFocus);
      // Make <i> elements "hidden" from screen reader
      const iElements = tabsetElement.querySelectorAll('a > i');
      iElements.forEach(ariaHide);
      // Cancel the callback
      clearInterval(aFocusCallback);
    }
    catch(e) {
      // An error occurred. Will run again in delay_ms ms.
    }
  }, delay_ms);
}

function setTabLinkIDs(delay_ms) {
  var setHighLevelIdsCallback = setInterval(function() {
    try {
      // Add id's to access links programmatically
      const tabsetElement = document.getElementById('tabset');
      const aElements = tabsetElement.querySelectorAll('a');
      aElements[0].setAttribute('id', 'home-link');
      aElements[0].setAttribute('role', 'tab');
      aElements[1].setAttribute('id', 'info-link');
      aElements[1].setAttribute('role', 'tab');
      aElements[2].setAttribute('id', 'equipment-link');
      aElements[2].setAttribute('role', 'tab');
      aElements[3].setAttribute('id', 'consumables-link');
      aElements[3].setAttribute('role', 'tab');
      aElements[4].setAttribute('id', 'staff-link');
      aElements[4].setAttribute('role', 'tab');
      aElements[5].setAttribute('id', 'other-link');
      aElements[5].setAttribute('role', 'tab');
      aElements[6].setAttribute('id', 'results-link');
      aElements[6].setAttribute('role', 'tab');
      clearInterval(setHighLevelIdsCallback);
    }
    catch(e) {}
  }, delay_ms);
}

function divTabpaneFocus(delay_ms) {
  var divTabpaneFocusCallback = setInterval(function() {
    try {
      var divHighestElement = document.getElementById('div_post_nav');
      var divTabpaneActiveElements = divHighestElement.getElementsByClassName('tab-pane active');
      divTabpaneActiveElements[0].setAttribute('tabindex', '-1');
      clearInterval(divTabpaneFocusCallback);
    }
    catch(e) {}
  }, delay_ms);
}

function adjustDatepicker(delay_ms) {
  var setHighLevelIdsCallback = setInterval(function() {
    try {
      var divDate = document.querySelector('div.datepicker');
      if (divDate !== null) {
        var thList = document.querySelectorAll('th.datepicker-switch');
        thList.forEach(function(element, index) {
          id_value = 'dpswitch' + index;
          element.setAttribute('id', id_value);
        })
        clearInterval(setHighLevelIdsCallback);
      } 
    }
    catch(e) {}
  }, delay_ms);
}
