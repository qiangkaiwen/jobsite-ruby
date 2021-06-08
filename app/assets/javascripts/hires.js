/**
 * Created by apple on 3/17/2020.
 */
function do_invite(id) {
    $.get("/hires/" + id + "/invitation", function (data, status) {
        if(status == 'success'){
            $("a#" + id).parent().append("<a onclick='do_hire(<%= hire.id %>)' id='<%= hire.id %>' href='/hires/<%= hire.id %>/hire'><i class='fa fa-heart'></i> Hire</a>")
            $("a#" + id).remove()
        }
    })
}

$(document).ready(function () {
    $('#a_suspend').click(function(){
        if (confirm('Are you sure?')) {
            location.replace('/hires/'+$('#input_suspend').val()+'/suspend')
        }
    })
})
