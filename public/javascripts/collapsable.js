(function( $ ) {
    $.fn.collapsable = function() {

        this.each(function(){
            var element = this;
            var collapse_control = $(element).find('.collapse_control')
            var list_content = $(element).find('.list_content')

            collapse_control.click(function(){
                if(list_content.is(':visible'))
                {
                    list_content.slideUp();
                }
                else
                {
                    list_content.slideDown();
                }
            });

        });

    };
})( jQuery );