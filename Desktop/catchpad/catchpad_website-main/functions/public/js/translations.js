(function ($) {
    "use strict";

    const defExDays = 365;

    const defaultLang = 'en';
    // we cant name it anything other that bcz firebase
    // hosting doesnt accept them.
    // https://github.com/firebase/quickstart-nodejs/issues/29
    const defaultLangCookieName = '__session';

    var language = defaultLang;

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
        d.setTime(d.getTime() + (defExDays * 24 * 60 * 60 * 1000));
        let expires = "expires=" + d.toUTCString();
        document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
        // console.log(document.cookie);
    }

    function isDefaultLanguage(lang) {
        return lang === defaultLang;
    }

    function initLangBtn() {
        var btn = $('.lang-btn');

        var iconName = '';
        isDefaultLanguage(language) ? iconName = 'tr' : iconName = 'us';

        btn.html(' <span class="fi fi-' + iconName + '"></span>');

        btn.click(function () {
            setLanguage(invLang(language));


            var newHref = window.location.href;
            // if newHref does not end with #, add one
            if (newHref.indexOf('#') === -1) {
                newHref += '#';
            }

            window.location.href = newHref;

            location.reload();
            return false;
        });
    }

    function setLanguage(lang) {
        // console.log('setLanguage: ' + lang);
        setCookie(defaultLangCookieName, lang);
    }

    function invLang(lang) {
        return (lang == 'en') ? 'tr' : 'en';
    }

    function getLanguage() {
        language = getCookie(defaultLangCookieName);

        initLangBtn();
    }

    getLanguage();

})(jQuery);