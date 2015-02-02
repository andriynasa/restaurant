# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
dateFormat = "dd-mm-yy"
$ ->
  window.param_paraser = () ->
    hashParams = {}
    e = ''
    a = /\+/g  
    r = /([^&;=]+)=?([^&;]*)/g
    d = (s) -> 
      decodeURIComponent(s.replace(a, " "))
    q = window.location.hash.split('?')[1]
    while (e = r.exec(q))
       hashParams[d(e[1])] = d(e[2])
    hashParams

  window.quaterHelper = (month)->
    quater = 1
    quater = 2 if month > 3 and month < 7
    quater = 3 if month > 6 and month < 10
    quater = 4 if month > 9
    quater

     
  window.calendar_state_date =  () ->
    date = new Date()
    date = window.calendar_state if window.calendar_state
    month = date.getMonth()+1
    month = window.quaterHelper(month) * 3 - 2 unless [1,4,7,10].indexOf(month) > 0
    new Date("#{date.getFullYear()}-#{month}-01")


  window.setQuater = ()->
    date = window.calendar_state_date()
      
    month = date.getMonth() + 1
    year = date.getFullYear()
    $('#calendar_header').html("Quarter #{window.quaterHelper(month)} '#{year}")


  window.datepicker_init_quater = (element_id, days_to_mark)->
    window.setQuater()
    $(element_id).datepicker
      firstDay: 1,
      dateFormat: dateFormat,
      numberOfMonths: 3
      showCurrentAtPos: 0
      defaultDate: window.calendar_state_date()
      stepMonths: 3
      onChangeMonthYear: (year, month, obj)->
        window.calendar_state = new Date("#{year}-#{month}-1")
        console.log "#{year}-#{month}-1"
        window.setQuater()
      
      beforeShowDay: (date)->
       
        day_of_week = date.getDay()
        return [true, 'weekend', ''] if day_of_week < 1 or day_of_week > 5
        default_day = [true, '', '']
        return default_day unless _.any(days_to_mark)
        
        mark_this_day = _.find days_to_mark, (entry)->
          day = new Date(entry.day).toLocaleDateString()
          date.toLocaleDateString() == day

        if mark_this_day
          [true, 'marked-as-holiday', mark_this_day.description]
        else
          default_day
          
      onSelect: (date, obj) ->
        date_formated = date.split('-').reverse().join('-')
        day_of_week = new Date(date_formated).getDay()
        return false if day_of_week < 1 or day_of_week > 5

        is_holiday = _.find days_to_mark, (entry)->
          date == entry.day.split('-').reverse().join('-')

        
        if is_holiday
          url = "/holidays/#{date}"
          title = date
        else
          url = "/holidays/new/?holiday_date=#{date}"
          title = "Add holiday #{date}"


        window.my_dialog url, title
      
    

  window.datepicker_init = ()->
    $("input.datepicker").each (i) ->
      $(this).datepicker
        firstDay: 1,
        dateFormat: dateFormat,
        changeMonth: true,
        changeYear: true
        yearRange: "2015:2017"
      $(@nextSibling).hide()  if @value is ""

    $(".clear-picker").click ->
      @previousSibling.value = null
      dp = @previousSibling
      changeClassToError($("#" + dp.id + ":required"), (dp.value is ""));
      $(this).hide()
      return

    $(".datepicker").change ->
      $(@nextSibling).show()  unless @value.length is ""
      return

  window.date_range_init = () ->
    $("input.date_range").each (i) ->
      _this = $(this)
      _field_name = _this.attr('data_field_name')
      help_obj = $('#date_range_help_' + _field_name)
      
      $(this).nextAll('a[href]:first').hide() if $(this).val().length == 0
      $(this).datepicker
        dateFormat: dateFormat,
        firstDay: 1,
        changeMonth: true,
        changeYear: true
        yearRange: "2015:2017",
        onSelect: (date, obj) ->
          
          $(".ui-datepicker a").removeAttr("href")
          
          if help_obj.val().length > 0
            dates = sortDates.call @, help_obj.val(), date
            val = "#{dates[0]}:#{dates[1]}"
            $(this).val val
          else
            help_obj.val(date)
            $(this).nextAll('a[href]:first').show()
            $.datepicker._updateDatepicker(this)

        onClose: (date, obj) ->
          if help_obj.val().length > 0
            help_obj.val('')
  
  window.date_range_init()
  window.datepicker_init()
  
  $(".apply-period").click ->
    params = '' #$('.apply-period').attr('data_params')
    url = window.location.origin + window.location.pathname
    $("input.date_range").each (i) ->
      return if $(this).val().length < 1
      params += "&" if params.length
      params += "#{$(this).attr('data_field_name')}=#{$(this).val()}"
    return false if params.length < 1
    $(location).attr('href', "#{url}?#{params}")
    return false
  
  $(".period-applied").click ->
    url = window.location.origin + window.location.pathname
    _field = $(this).attr "field"
    
    params = $("a[data_field='#{_field}']").attr('data_params')
    $(location).attr('href', "#{url}?#{params}")
    return false

sortDates = (date1, date2) ->
  d1 = $.datepicker.parseDate(dateFormat, date1)
  d2 = $.datepicker.parseDate(dateFormat, date2)
  if(d1 > d2)
    [date2, date1]
  else
    [date1, date2]


$(document).on "click", ".toggler", (e) ->
  e.preventDefault()
  $(".child-" + @id).toggle 300
  return
  
window.onload = ()->
  $(".hideme").hide()
  return
