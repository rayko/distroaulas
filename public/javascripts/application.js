// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Ajax update for event career field
jQuery(function($) {
    // when the #search field changes
    $("#event_plan").change(function() {
        // make a POST call and replace the content
        $.ajax({
            url: "/ajax_careers_by_plan/" + this.value, //I think, it could be something else
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function(data) {
                var i = 0;
                var select_options = '';

                // Get the element to update
                select_field = document.getElementById('event_career')

                // Clear select options
                select_field.options.length = 0

                // Add new options
                for(i = 0; i <= data.length - 1; i++) {
                    select_field.options.add(new Option(data[i].career.name, data[i].career.id));
                };
            },
            error: function(xhr,exception,status) {
                //catch any errors here
            }
        });
    });
});
