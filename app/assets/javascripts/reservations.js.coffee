ready = ->
  $('.timepicker').timepicker
    'step': 30
    'timeFormat': 'H:i'
  $('.table_num').timepicker
    'timeFormat': 'H'
    'step': 60
  $('.rest-table').click ->
    $("#reservation_table_number").val $(this).attr('value')
    return
  return
$(document).ready(ready)
$(document).on('page:load', ready)
