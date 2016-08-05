# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
 $(document).on "ready", ->
   $("input#checkbox_select_all_lessons").click ->
     $("input[name='lesson_id[]']").click()
