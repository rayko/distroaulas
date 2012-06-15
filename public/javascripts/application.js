// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults




// Autocomplete in search responsable
$(document).ready(function(){
    $('#search_responsible').focus(function(){
        // get tokens
        $.ajax({
            url: '/ajax_get_responsibles_list',
            dataType: 'json',
            contentType: 'application/json; charset=utf-8',
            beforeSend: function(xhr){
                $('.responsible-loading').show()
            },
            success: function(data){
                $('.responsible-loading').hide()
                $('#search_responsible').autocomplete({source: data})
            },
            error: function(xhr,exeption,status){
                // errors?
            }
        });


    });

});

// Callbacks for search section
$(document).ready(function(){
    $('form[data-remote]').bind('ajax:beforeSend', function(){
        $('#search_submit')[0].disabled = true
        $('.search-loading').show()
    });
    $('form[data-remote]').bind('ajax:success', function(){
        $('#search_submit')[0].disabled = false
        $('.search-loading').hide()
        $('input.ui-date-picker').datepicker();
        // Select all check for search events
        $('#select_all').click(function(){
            if($('#select_all').is(':checked')){
                $('.selectable').attr('checked', true)
            }
            else{
                $('.selectable').attr('checked', false)
            };
        });
        // this doesn't work $("div#search_result").html("escape_javascript(render :partial => 'search_result', :locals => {:events => @events}) ")
    });
});

//ajax for free spaces on event form
jQuery(function($) {
    $("#check_free_spaces").click(function() {
        date = document.getElementById('event_start_date').value
        start_hour = document.getElementById('event_start_time_4i').value
        start_min = document.getElementById('event_start_time_5i').value
        end_hour = document.getElementById('event_end_time_4i').value
        end_min = document.getElementById('event_end_time_5i').value
        errors = ''

        if(date == ''){
            errors += "No date provided\n"
        }

        if(start_hour == ''){
            errors += "No start hour provided\n"
        }

        if(start_min == ''){
            errors += "No start minute provided\n"
        }

        if(end_hour == ''){
            errors += "No end hour provided\n"
        }

        if(end_min == ''){
            errors += "No end minute provided\n"
        }
        start = date + ' ' + start_hour + ':' + start_min + '-0300'
        end = date + ' ' + end_hour + ':' + end_min + '-0300'

        if(errors != ''){
            alert(errors)
        }
        else{
            $.ajax({
                url: "/ajax_free_spaces/?start=" + start + '&end=' + end, //I think, it could be something else
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                beforeSend: function(xhr) {
                    $('.spaces-loading').show();
                },
                success: function(data) {
                    $('.spaces-loading').hide();
                    var i = 0;


                    // Get the element to update
                    select_field = document.getElementById('event_space_id');

                    // Clear select options
                    select_field.options.length = 0;

                    // Append blank element
                    select_field.options.add(new Option('---', ''));

                    // Add new options
                    for(i = 0; i <= data.length - 1; i++) {
                        select_field.options.add(new Option(data[i].space.name, data[i].space.id));
                    };

                    //alert(data)
                    if(data.length == 0){
                        alert('No free spaces found');
                    }
                },
                error: function(xhr,exception,status) {
                //catch any errors here
                }
            });
        }
    });
});

//qTip
$(document).ready(function(){
    $('.qtip-event').each(function(){
        $(this).qtip({
            content: {
                url: '/events/tip_summary/' + this.attributes.qtip_event_id.value
            },
            position: {
                corner: {
                    target: 'rightMiddle'
                    //tooltip: 'leftMiddle'
                },
            },
            style: {
                width: 400,
                name: 'blue',
                tip: 'leftTop'
            }
        })
    })
})

$(document).ready(function()
{
   // Use the each() method to gain access to each of the elements attributes
   $('.qtip-able').each(function()
   {
      $(this).qtip(
      {
          content: this.attributes.qtip_text.value, // Give it some content
          position: {
              corner: {
                  target: 'topRight',
                  tooltip: 'bottomLeft'
              }
          },
          style: {
              name: 'blue',
              tip: 'bottomLeft'
          }
      });
   });
});

// Auto fill responsable field on event from matter field
jQuery(function($) {
    $("#event_matter_id").change(function() {
        responsible_field = document.getElementById("event_responsible")
        $.ajax({
            url: "/matters/" + document.getElementById("event_matter_id").value,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            beforeSend: function(xhr) {
                $('.responsible-loading').show();
                responsible_field.disabled = true;
            },
            success: function(data) {
                $('.responsible-loading').hide();
                responsible_field.disabled = false;
                document.getElementById("event_responsible").value = data["matter"]["responsible"]
            },
        });
    });
});

// Ajax update for event career field
jQuery(function($) {
    $("#search_plan").change(function() {
        // make a POST call and replace the content
        if (this.value) {
            $.ajax({
                url: "/ajax_careers_by_plan/" + this.value, //I think, it could be something else
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                beforeSend: function(xhr) {
                    $('.career-loading').show();
                },
                success: function(data) {
                    $('.career-loading').hide();
                    var i = 0;

                    // Get the element to update
                    select_field = document.getElementById('search_career_id');

                    // Clear select options
                    select_field.options.length = 0;

                    // Append blank element
                    select_field.options.add(new Option('---', ''));

                    // Add new options
                    for(i = 0; i <= data.length - 1; i++) {
                        select_field.options.add(new Option(data[i].career.name, data[i].career.id));
                    };
                },
                error: function(xhr,exception,status) {
                //catch any errors here
                }
            });
        };
    });
});


// Ajax update for event career field
jQuery(function($) {
    $("#event_plan").change(function() {
        // make a POST call and replace the content
        if (this.value) {
            $.ajax({
                url: "/ajax_careers_by_plan/" + this.value, //I think, it could be something else
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                beforeSend: function(xhr) {
                    $('.career-loading').show();
                    $('.matter-loading').show();
                },
                success: function(data) {
                    $('.career-loading').hide();
                    $('.matter-loading').hide();
                    var i = 0;

                    // Get the element to update
                    select_field = document.getElementById('event_career');

                    // Get matter element
                    select_matter = document.getElementById('event_matter_id');

                    // Clear matters select for consistency
                    select_matter.length = 0;

                    // Clear select options
                    select_field.options.length = 0;

                    // Append blank element
                    select_field.options.add(new Option('---', ''));

                    // Add new options
                    for(i = 0; i <= data.length - 1; i++) {
                        select_field.options.add(new Option(data[i].career.name, data[i].career.id));
                    };
                },
                error: function(xhr,exception,status) {
                //catch any errors here
                }
            });
        };
    });
});


// Ajax update for event matter field
jQuery(function($) {
    $("#event_career").change(function() {
        // make a POST call and replace the content
        if (this.value) {
            $.ajax({
                url: "/ajax_get_matters_by_career/" + this.value,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                beforeSend: function(xhr){
                    $('.matter-loading').show();
                },
                success: function(data) {
                    $('.matter-loading').hide();
                    var i = 0;

                    // Get the element to update
                    select_field = document.getElementById('event_matter_id');

                    // Clear select options
                    select_field.options.length = 0;

                    // Append blank element
                    select_field.options.add(new Option('---', ''));

                    // Add new options
                    for(i = 0; i <= data.length - 1; i++) {
                        select_field.options.add(new Option(data[i].matter.name, data[i].matter.id));
                    };
                },
                error: function(xhr,exception,status) {
                    //catch any errors here
                }
            });
        };
    });
});

// Updates event name with calendar name plus matter name
jQuery(function($) {
    $("#event_matter_id").change(function() {
        var calendar = document.getElementById('event_calendar_id')
        document.getElementById("event_name").value = calendar.options[calendar.selectedIndex].text + ' - ' + this.options[this.selectedIndex].text;
    });
});

// Hidde event recurrent fields on form load
jQuery(function($) {
    $('#new_event').ready(function() {
        recurrent_options = document.getElementById('event_recurrent');
        if (recurrent_options) {
            if (document.getElementById('event_recurrent').checked) {
                document.getElementById('event_count_input').style['display'] = '';
                document.getElementById('event_freq_input').style['display'] = '';
                document.getElementById('event_interval_input').style['display'] = '';
                document.getElementById('event_byday_input').style['display'] = '';
                document.getElementById('event_until_date_input').style['display'] = '';
            }
            else {
                document.getElementById('event_until_date_input').style['display'] = 'none';
                document.getElementById('event_count_input').style['display'] = 'none';
                document.getElementById('event_freq_input').style['display'] = 'none';
                document.getElementById('event_interval_input').style['display'] = 'none';
                document.getElementById('event_byday_input').style['display'] = 'none';
            };
        };
    });
});

// Event recurrent fields show/hidde
jQuery(function($) {
    $('#event_recurrent').change(function() {
        if (this.checked) {
            document.getElementById('event_count_input').style['display'] = '';
            document.getElementById('event_freq_input').style['display'] = '';
            document.getElementById('event_interval_input').style['display'] = '';
            document.getElementById('event_byday_input').style['display'] = '';
            document.getElementById('event_until_date_input').style['display'] = '';
        }
        else {
            document.getElementById('event_until_date_input').style['display'] = 'none';
            document.getElementById('event_count_input').style['display'] = 'none';
            document.getElementById('event_freq_input').style['display'] = 'none';
            document.getElementById('event_interval_input').style['display'] = 'none';
            document.getElementById('event_byday_input').style['display'] = 'none';
        };
    });
});

// Datepicker
$(document).ready(function(){
  $('input.ui-date-picker').datepicker();
});

// Filter toggle button to hide/show filter options on events view
jQuery(function($) {
    $("input#toggle_filter").click(function () {
        if (this.checked) {
            $('div#datetime_event_filter').show("fold", {}, 1000);
        }
        else {
            $('div#datetime_event_filter').hide("fold", {}, 1000);
        };
    });
});

// Clock
jQuery(function($) {
     $("div#clock").clock({"langSet":"es"});
});

// Tagbox
jQuery(function() {
    $(".rdate-tagbox").tagit();
});

jQuery(function() {
    $(".exdate-tagbox").tagit();
});

// Makes the tagboxes read only
$(document).ready(function() {
    tagit_fields = $('input.tagit-new-field')
    if (tagit_fields.length > 0) {
        for (i = 0; i < tagit_fields.length; i++) {
            tagit_fields[i].readOnly = true
        };
    };
});

jQuery(function() {
    $(".add_new_rdate").click(function() {
        $(".rdate-tagbox").tagit('createTag', document.getElementById('rdate_picker').value);
    });
});


jQuery(function() {
    $(".add_new_exdate").click(function() {
        $(".exdate-tagbox").tagit('createTag', document.getElementById('exdate_picker').value);
    });
});
