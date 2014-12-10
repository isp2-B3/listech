(function($){
$(function(){
    $(document)
        .on('click', '.popup_btn', function(){
            var $popup = $((this).attr('href'));

            // ポップアップの幅と高さからmarginを計算する
            var mT = ($popup.outerHeight() / 2) * (-1) + 'px';
            var mL = ($popup.outerWidth() / 2) * (-1) + 'px';

            // marginを設定して表示
            $('.popup').hide();
            $popup.css({
                'margin-top': mT,
                'margin-left': mL
            }).show();
            $('#overlay').show();

            return false;
        })
        .on('click', '.close_btn, #overlay', function(){
            $('.popup, #overlay').hide();
            return false;
        });
});
})(jQuery);