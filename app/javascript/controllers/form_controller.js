
import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";


export default class extends ApplicationController {


}





// helpers for nested forms
function insert_fields(link, method, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + method, "g")
  if (content.match(/^\s*<tr\b/)) {
    // Add it to a table
    $(content.replace(regexp,new_id)).appendTo($(link).parents('fieldset').children('table:last'));
  } else if (content.match(/^\s*<li\b/)) {
    // Add it to a ul
    $(content.replace(regexp,new_id)).appendTo($(link).parents('fieldset').children('ul:last'));
  } else {
    $(content.replace(regexp,new_id)).insertAfter($(link).parents('fieldset').children(':last'));
  }
}

function remove_fields(link) {
  $('input[type=hidden][name*="[_destroy]"]', $(link).parent()).val('true');
  if ($(link).parents('.fields').size()>0) {
    $(link).parents('.fields').first().hide();
    $('input, select, textarea',$(link).parents('.fields').first()).prop('required',false);
  }
}

function hide_removed_records() {
  $('input[type=hidden][value=true][name$="[_destroy]"], input[type=checkbox][checked][value=1][name$="[_destroy]"]').each(function() {
    if ($(this).parents('.fields').size()>0) {
      $(this).parents('.fields').first().hide();
      $('input',$(link).parents('.fields').first()).prop('required',false);
    }
  });
}

$(document).ready(function() {
  hide_removed_records();
