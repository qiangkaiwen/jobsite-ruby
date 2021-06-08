
var socket = io.connect('http://192.1.1.200:8001');

socket.on('alarm_invitation', function(data) {
    alarm_invitation();
});

alarm_invitation();

function alarm_invitation() {
    $.ajax({
        url: '/hires/new_invitation',
        type: 'get',
        success: function (res) {
            if (res == 'fail') 
                return;
            if (res.length > 0 && !document.getElementById("alarmIcon")) {
                $('#contract-menu').append('<i id="alarmIcon" class="fa fa-bell pull-right" style="color:red"></i>');
            }
        }
    })
}

$(document).ready(function () {
    
    $('.invitation-btn').click(function () {
        socket.emit('alarm_invitation', 'hey! please receive!')
    });

    $('#signin').click(function () {
        var form = $(this).closest('form')
        $('input[name=authenticity_token]').val($('meta[name=csrf-token]').attr('content'))
        $(form).submit()
    })

    $('#signup').click(function() {
        var form = $(this).closest('form')
        if ($(form).find('input#username').val().trim() == '') {
            alert('empty Username')
            return;
        }
        if ($(form).find('input#userpassword').val() == '') {
            alert('empty Password')
            return;
        }
        if ($(form).find('input#userpassword').val() != $(form).find('input#confirmpassword').val()) {
            alert('Passwords are dismatch.')
            return;
        }
        // if ($(form).find('input#userimage_url').val() == '') {
        //     alert("Avatar doesn't set")
        //     return;
        // }
        $('input[name=authenticity_token]').val($('meta[name=csrf-token]').attr('content'))

        $(form).submit()
    })

    $('.user_used').change(function() {
        // console.log($(this).attr('id'))
        let send_data = { user_id : $(this).attr('id') }
        $.ajax({
            url: '/users/exchange_used',
            type: 'get',
            data: { send_data },
            success: function (res) {
                if (res == "success") {
                    alert("Success!")
                }
            }
        })
    })
})