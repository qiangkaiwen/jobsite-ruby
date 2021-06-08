
var selected_hire_id = 0;

$(document).ready(function () {
    if ($('input#freelancer_hire_id').length > 0){
        var hire_id = $('input#freelancer_hire_id').val();
        console.log(hire_id)
        var send_data = {action:'request_invite', room_id:hire_id}
        socket.emit('on message', send_data)
    }
})

//filterChatsByUser();
socket.on('on message', function(data) {
    
    if (data.action = 'send_chat') {
        var cur_hire_id;
        if ($('input#freelancer_hire_id').length > 0){
            //if user is freelancer then
            cur_hire_id = $('input#freelancer_hire_id').val();
        }
        else{
            cur_hire_id = selected_hire_id;
        }
        if (data.hire_id == cur_hire_id) {
            console.log('receive chat message')
            getChatsByUser()
        }
        else{
            console.log('tip====', data.hire_id ,':', cur_hire_id)
            if (data.hire_id != undefined && data.hire_id > 0) {
                makeTipForUser(data.hire_id);
            }
        }
    }
});

socket.on('kicked', function(data) {
    if(window.location.pathname != '/chats/' + data.job_id) return;
    $.ajax({
        url: '/chats/check_kicked',
        type: 'get',
        data: { send_data : data },
        success: function (res) {
            if(res == 'kicked')
            {
                alert("You are kicked!");
                window.location = '/hires/' + data.job_id;
            }
        },
        error: function(err) {
            console.log("kick_out failed");
        }
    });
});

$('#chats-content').animate(
{
    scrollTop: $('.chat-list').height()
}, 500);

// $('.invitation-users:first').click();
// console.log($('a.invitation-users:first'))

$('.invitation-users').click(function() {
    $('.invitation-users').attr('style', '');
    $(this).attr('style', 'background-color:lightgrey;');

    selected_hire_id = $(this).attr('id');
    var send_data = {action:'request_invite', room_id:selected_hire_id};
    socket.emit('on message', send_data);

    var selector = 'a#' + selected_hire_id + '> span'
    $(selector).remove('.tip')
    $('#non_chat').remove()
    getChatsByUser();
    getBidByUser();
});


$('#post').click(function() {
    var msg = $('#chat_content').val().trim();
    if (verify_user_and_data(msg) == 1)
        sendChat(msg);
});

$('#chat_content').keypress(function (e) {
    if ((e.ctrlKey || e.metaKey) && (e.keyCode == 13 || e.keyCode == 10)) {
        var msg = $('#chat_content').val().trim();
        if (verify_user_and_data(msg) == 1)
            sendChat(msg);
    }
});

function kick_clicked(kicked_user_id) {
    if(!confirm("Are you sure?"))
        return;
    var send_data = {
        kicked_user_id, 
        job_id : $('#job_id').val()
    }
    $.ajax({
        url: '/chats/kick_out',
        type: 'get',
        data: { send_data },
        success: function (res) {
            socket.emit('kicked', send_data);
            window.location = '/chats/' + send_data.job_id;
        },
        error: function(err) {
            console.log("kick_out failed");
        }
    });
}

function verify_user_and_data(msg){
    if ( $('#is_freelancer').val() == 'client' && selected_hire_id == 0) {
        alert("Please select User you wanna with.");
        return 0;
    }
    if (msg == ''){
        alert('empty message!');
        return 0;
    }
    return 1;
}

function makeTipForUser(hire_id){
    var user_span = 'a#'+hire_id+' > span';
    if($(user_span).length == 0){
        $('a#'+hire_id).append('<span class="tip">1</span>')
    }
    else{
        var prev_cnt = $(user_span).text();
        prev_cnt++;
        $(user_span).html(prev_cnt)
    }
}

function getChatsByUser() {
    var send_data = {
            selected_hire_id:  selected_hire_id == 0 ? $('#hire_id').val() : selected_hire_id
            , job_id: $('#job_id').val()};
    $.ajax({
        url: '/chats/filter_by_user',
        type: 'get',
        data: { send_data },
        success: function (res) {
            // $('.invitation-users').append('<span class="tip">2</span>');
            $('#chats-content').html(res);
            $('#chats-content').animate(
            {
                scrollTop: $('.chat-list').height()
            }, 500);
        }
    })
}

function getBidByUser() {
    var send_data = {
            selected_hire_id: selected_hire_id
            , job_id: $('#job_id').val()};
    $.ajax({
        url: '/chats/bid_by_user',
        type: 'get',
        data: { send_data },
        success: function (res) {
            $('#bid-content').html(res);
        },
        error : function (err) {
            console.log("bid_by_user failed");
        }
    })
}

function sendChat(msg) {
    
    var send_data = {
        action: 'send_chat'
        , content: msg
        , user_id: $('#user_id').val()
        , hire_id: selected_hire_id == 0 ? $('#hire_id').val() : selected_hire_id
        , job_id: $('#job_id').val()
    };
    $.ajax({
        url: '/chats/msg',
        type: 'get',
        data: { send_data },
        success: function (res) {
            
            if (res == 'success') {
                //console.log("success")
                $('#chat_content').val('').focus();
                socket.emit('on message', send_data)
            }else if (res == 'fail') {
                //console.log("fail")
                alert('Failed Sending Chat !')
            }
        }
    })
}
