// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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