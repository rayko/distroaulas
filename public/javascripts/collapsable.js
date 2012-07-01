(function( $ ) {
    $.fn.collapsable = function() {

        this.each(function(){
            var element = this;
            var collapse_control = $(element).find('.collapse_control')
            var list_content = $(element).find('.list_content')

            collapse_control.click(function(){
                list_content.toggle();
            });

        });

    };
})( jQuery );