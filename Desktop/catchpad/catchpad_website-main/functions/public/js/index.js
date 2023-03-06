(function($) {
    "use strict";

    var hasListener = false;

    function setCpNiElements(val) {
        // loop all elements with class cp_ni,
        // if val == dark, then remove cp_ni_light class, and add cp_ni_dark class,
        // vice versa
        $('.cp_ni').each(function() {
            if (val === 'dark') {
                $(this).removeClass('cp_ni_light').addClass('cp_ni_dark');
            } else {
                $(this).removeClass('cp_ni_dark').addClass('cp_ni_light');
            }
        });
    }

    function onScroll() {
        hasListener = true;

        // the video currently is in full screen,
        // so we will get the screen height. dividing
        // by 2 gives a much nicer effect
        var height = window.innerHeight / 2;

        let navbar_top = document.getElementById('navbar_top')
        let navbar_pre_btn = document.getElementById('navbar_pre_btn')
        if (window.scrollY > height) {
            navbar_top.classList.remove('bg-transparent');
            navbar_top.classList.add('bg-dark');

            setCpNiElements('light');

            navbar_pre_btn.classList.remove('d-none');
        } else {
            navbar_top.classList.add('bg-transparent');
            navbar_top.classList.remove('bg-dark');
            setCpNiElements('dark');

            // remove padding top from body
            document.body.style.paddingTop = '0';

            navbar_pre_btn.classList.add('d-none');
        }
    }

    function navbarTransparency() {
        if (!isOnMobile()) {
            // to initially set the transparency
            onScroll();

            // then give the pagge negative margin
            // to merge it with the navbar

            var navbar = document.querySelector('.cp-main-navbar').offsetHeight;

            var hight = navbar;

            var page_wrap = document.getElementById('cp_page_wrapper');
            page_wrap.style.marginTop = -hight + 'px';

            if (hasListener) {
                window.removeEventListener('scroll', onScroll);
            }
            // and handle the navbar background change on scroll
            window.addEventListener('scroll', onScroll);
        }
    }

    function isOnMobile() {
        return window.innerWidth < 992;
    }


    function vidSizing() {
        var offerbarH = document.querySelector('.cp-offer-navbar').offsetHeight;

        // get element with tag video in vid_wrapper
        var video = document.querySelector('.cp_trailer_video');
        var wrapper = document.querySelector('.cp_trailer_video_wrapper');

        if (isOnMobile()) {
            video.style.height = '100%';
        } else {
            var h = $(window).height() - offerbarH + 'px'

            video.style.height = h;
            wrapper.style.height = h;
        }

    }

    // we're gonna run it on page load,
    // also on resize
    function pageSizer() {

        navbarTransparency();

        vidSizing();
    }

    document.addEventListener("DOMContentLoaded", function() {

        pageSizer();

        $(window).resize(function() {
            pageSizer();
        });
    });

    const sectionNavHandler = (event, href) => {

        // set the url to the href
        window.history.pushState({}, '', href);

        // get the section with the id of the href
        let section = document.getElementById(href.split('#')[1])

        event.preventDefault()

        // scroll to section's position + navbar height
        window.scrollTo({
            top: section.offsetTop - navbar_height,
            behavior: 'smooth'
        })
    }

    let sectionLinks = document.getElementsByClassName('cp_ni_index')
    var navbar_height = navbar_top.offsetHeight

    for (let i = 0; i < sectionLinks.length; i++) {
        let sectionLink = sectionLinks[i]

        // disable the default behavior of the link

        sectionLink.addEventListener('click', (event) => {
            // get the href of the sectionLink
            let href = sectionLink.getAttribute('href')

            sectionNavHandler(event, href)
        })
    }


})(jQuery);