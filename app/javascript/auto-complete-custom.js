import 'js-autocomplete/auto-complete.css';
import autocomplete from 'js-autocomplete/auto-complete.js';

function createAutoComplete(data, searchInput) {
  //alert('AutoCompleteFunction: ' + data);
  //if (searchInput)
  //  alert('AutoCompleteFunction: ' + searchInput.id);

  if (data && searchInput) {
    new autocomplete({
      selector: searchInput,
      minChars: 1,
      source: function(term, suggest){
          term = term.toLowerCase();
          var choices = data;
          var suggestions = [];
          for (var i=0;i<choices.length;i++)
              if (~choices[i].toLowerCase().indexOf(term)) suggestions.push(choices[i]);
          suggest(suggestions);
      }
    });
  }
}

/*
  TODO: CHANGE data TO GET FROM AJAX QUERY
*/
function tagAutoCompleteFunction() {
  var data;
  if (document.getElementById('search-data-tag'))
    data = JSON.parse(document.getElementById('search-data-tag').dataset.skills);
  var searchInput = document.getElementById('tag_text');

  createAutoComplete(data, searchInput);
}

/*
  TODO: CHANGE data TO GET FROM AJAX QUERY
*/
function yearAutoCompleteFunction() {
  var data;
  if (document.getElementById('search-data-year'))
    data = JSON.parse(document.getElementById('search-data-year').dataset.skills);
  var searchInput = document.getElementById('year_text');

  createAutoComplete(data, searchInput);
}

/*
  TODO: CHANGE data TO GET FROM AJAX QUERY
*/
function subjectAutoCompleteFunction() {
  var data;
  if (document.getElementById('search-data-subject'))
    data = JSON.parse(document.getElementById('search-data-subject').dataset.skills);
  var searchInput = document.getElementById('subject_text');

  createAutoComplete(data, searchInput);
}

/*
  TODO: CHANGE data TO GET FROM AJAX QUERY
*/
function topicAutoCompleteFunction() {
  var data;
  if (document.getElementById('search-data-topic'))
    data = JSON.parse(document.getElementById('search-data-topic').dataset.skills);
  var searchInput = document.getElementById('topic_text');

  createAutoComplete(data, searchInput);
}

function initializationFunctions() {
  tagAutoCompleteFunction();
  yearAutoCompleteFunction();
  subjectAutoCompleteFunction();
  topicAutoCompleteFunction();
}

$(document).on('turbolinks:load', function() {
  initializationFunctions();
})
