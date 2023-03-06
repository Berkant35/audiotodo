(function ($) {
    "use strict";

    // Form
    var orderForm = function () {

        var form = document.forms['orderForm'];

        var name = form['name'];
        var email = form['email'];

        var nameError = $('#name-error');
        var emailError = $('#email-error');

        function toggleErrors() {
            var err = false;

            // check if all fields are filled
            if (name.value.length <= 0) {
                err = true;
                nameError.show();
            } else {
                nameError.hide();
            }

            if (email.value.length <= 0) {
                err = true;
                emailError.show();
            } else {
                emailError.hide();
            }

            return err;
        }

        function loading(e) {
            // get element with send-msg-loading id, and 
            // if e,
            // remove class d-none and add class d-inline,
            // else, vice versa	

            var loading = $('#send-msg-loading');

            if (e) {
                loading.removeClass('d-none');
                loading.addClass('d-inline-block');
            } else {
                loading.removeClass('d-inline-block');
                loading.addClass('d-none');
            }

        }

        var $form = $('#orderForm');
        $form.on('submit', submitHandler);

        function submitHandler(e) {
            e.preventDefault();

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
                url: `/${lang}/order`,
                data: $form.serialize(),
                success: function (msg) {
                    if (msg == '200') {
                        $('#form-message-warning').hide();
                        $('#form-failed-warning').hide();
                        setTimeout(function () {
                            $('#orderForm').fadeIn();
                        }, 1000);

                        setTimeout(function () {
                            $('#form-message-success').fadeIn();
                        }, 1400);

                        setTimeout(function () {
                            $('#form-message-success').fadeOut();
                        }, 8000);


                        setTimeout(function () {
                            $('#orderForm').each(function () {
                                this.reset();
                            });
                        }, 1400);

                    } else {
                        $('#form-message-warning').html(msg);
                        $('#form-message-warning').fadeIn();
                    }

                    loading(false);


                    setTimeout(function () {

                        $(function () {
                            $('#orderModal').modal('toggle');
                        });
                    }, 4000);
                },
                error: function () {
                    $('#form-failed-warning').fadeIn();
                    loading(false);
                }
            });

        }
    };
    orderForm();

})(jQuery);