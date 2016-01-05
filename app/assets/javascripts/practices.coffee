# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
 $(document).on "ready", ->
   $("input#checkbox_select_all_practices").click ->
     $("input[name='practice_id[]']").click()
