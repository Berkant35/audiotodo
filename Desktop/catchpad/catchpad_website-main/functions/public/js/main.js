(function ($) {
    "use strict";

    $('.nav-link').on('click', function () {
        $('.navbar-collapse').collapse('hide');
    });

    document.addEventListener("DOMContentLoaded", function () {
        var navbar_height = document.querySelector('#navbar_top').offsetHeight
        var cp_page_wrapper = document.getElementById('cp_page_wrapper');
        cp_page_wrapper.style.paddingTop = navbar_height + 'px';
    });


    const acceptCookiesKey = 'accept_cookies'

    const dismissedNewsLetterKey = 'dismissed_news_letter'
    const acceptedNewsLetterKey = 'accepted_news_letter'


    const cookieBarId = '#cookies_bar',
        newsLetterBarId = '#news-letter-bar'

    // we dont wanna call this before cookie consent is accepted,
    // however, it will be called anyway after consent with different
    // permissions. there will be full tracking if the user accepts the
    // cookies, but only pageview tracking will be done if the user
    // does not accept the cookies.
    function initGoogleTag() {
        (function (w, d, s, l, i) {
            w[l] = w[l] || [];
            w[l].push({
                'gtm.start': new Date().getTime(),
                event: 'gtm.js'
            });
            var f = d.getElementsByTagName(s)[0],
                j = d.createElement(s),
                dl = l != 'dataLayer' ? '&l=' + l : '';
            j.async = true;
            j.src =
                'https://www.googletagmanager.com/gtm.js?id=' + i + dl;
            f.parentNode.insertBefore(j, f);
        })(window, document, 'script', 'dataLayer', 'GTM-MHK2MRX');


        // insert tthis iframe in the body
        // <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-MHK2MRX" height="0" width="0"
        // 		style="display:none;visibility:hidden"></iframe></noscript>
        document.querySelector('body').insertAdjacentHTML('beforeend', '<iframe src="https://www.googletagmanager.com/ns.html?id=GTM-MHK2MRX" height="0" width="0" style="display:none;visibility:hidden"></iframe>');
    }

    // getCookies method should fetch cookies and return them as an array
    function getCookies() {
        var cookies = document.cookie.split(';');

        var cookieArray = [];

        for (var i = 0; i < cookies.length; i++) {
            cookieArray.push(cookies[i].split('='));
        }

        return cookieArray;
    }

    function getCookie(key) {
        var cookies = getCookies();
        for (var i = 0; i < cookies.length; i++) {
            if (cookies[i][0].trim() === key) {
                return cookies[i][1];
            }
        }

        return null;
    }

    function setCookie(cname, cvalue) {
        const d = new Date();
        d.setTime(d.getTime() + (365 * 24 * 60 * 60 * 1000));
        let expires = "expires=" + d.toUTCString();
        document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
        // console.log(document.cookie);
    }

    function newsLetterCheck() {
        let acceptedNewsLetter = getCookie(acceptedNewsLetterKey),
            dismissedNewsLetter = getCookie(dismissedNewsLetterKey)

        if (acceptedNewsLetter || dismissedNewsLetter) {
            return;
        }

        // we wanna show the news letter bar after 4 seconds
        setTimeout(function () {
            $(newsLetterBarId).fadeIn()
        }, 4000);

    }

    function initCheck() {
        // we wanna check the cookies if they include the key 'allowed_cookies'
        // if they dont, we will show the cookies bar
        if (!getCookie(acceptCookiesKey)) {
            // fade in the cookies bar after 1 second
            setTimeout(function () {
                $(cookieBarId).fadeIn();
            }, 1000);
        } else {
            // if the cookies are accepted, first we wanna init google tag,
            // and call newsLetterCheck and leave it do the rest
            initGoogleTag()
            newsLetterCheck()
        }
    }

    function cookieBtnClick() {
        $(cookieBarId).hide()
        initCheck()
    }

    function newsLetterBtnClick() {
        $(newsLetterBarId).fadeOut()
    }

    function handleNewsLetterForm() {
        var form = document.forms['newsLetterForm'];

        var email = form['email'];

        function toggleErrors() {
            // whats happening here is we're specifying the elemtns under our form
            // because they are being confused with the other form.

            var emailError = $('form #email-error');

            var err = false;

            if (email.value.length <= 0 || !email.value.includes('@')) {
                err = true;
                emailError.show()
            } else {
                emailError.hide()
            }

            return err;
        }

        function loading(e) {
            // get element with send-msg-loading id, and 
            // if e,
            // remove class d-none and add class d-inline,
            // else, vice versa	

            var loading = $(formId + ' #send-msg-loading');

            if (e) {
                loading.removeClass('d-none');
                loading.addClass('d-inline-block');
            } else {
                loading.removeClass('d-inline-block');
                loading.addClass('d-none');
            }

        }

        const formId = '#newsLetterForm'
        const newsLetterBarId = '#news-letter-bar'

        let $form = $(formId)
        let $newsLetter = $(newsLetterBarId)
        // $form.on('submit', function(e) { e.preventDefault() })

        let $formSubmitBtn = $(formId + ' #news-letter-submit-btn')
        $formSubmitBtn.click(submitHandler)

        function submitHandler(e) {

            e.preventDefault();

            function onSuccess(msg) {
                if (msg == '200') {
                    $(newsLetterBarId + ' #form-message-warning').hide();
                    $(newsLetterBarId + ' #form-failed-warning').hide();

                    $(newsLetterBarId + ' #modal-body-wrapper').hide();
                    $(newsLetterBarId + ' #form-message-success').show();

                    setTimeout(function () {
                        $(newsLetterBarId + ' #modal-body').fadeOut();

                        setCookie(acceptedNewsLetterKey, 'true')
                        newsLetterBtnClick()
                    }, 3000);

                } else {
                    $(newsLetterBarId + ' #form-message-warning').html(msg);
                    $(newsLetterBarId + ' #form-message-warning').fadeIn();
                }

                loading(false);
            }


            // console.log($form.serialize());

            var err = toggleErrors();
            if (err) return;

            loading(true);

            // get current route
            var route = window.location.pathname
            // the route goes like this:
            // /{lang}/blah
            let lang = route.split('/')[1]


            $.ajax({
                type: "POST",
                url: `/${lang}/news_letter`,
                data: $form.serialize(),
                success: onSuccess,
                error: function () {
                    $(newsLetterBarId + ' #form-failed-warning').fadeIn()
                    loading(false)
                    setTimeout(function () {
                        newsLetterBtnClick()
                    }, 3000);
                }
            });

        }
    }

    $("#accept_cookies").click(function () {
        setCookie(acceptCookiesKey, 'true')
        cookieBtnClick()
    });

    $("#dismiss-news-letter").click(function () {
        setCookie(dismissedNewsLetterKey, 'true')
        newsLetterBtnClick()
    })

    // $("#reject_cookies").click(function() {
    //     cookieBtnClick();
    //     setCookie(acceptCookiesKey, 'false');
    // });

    initCheck()
    handleNewsLetterForm()

})(jQuery);