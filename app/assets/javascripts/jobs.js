/**
 * Created by apple on 3/19/2020.
 */
socket.on('newJob', function (job) {
    console.log(job)
    var day = job.reg_date.slice(8, 10);
    var monthName = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    var regMonth = (job.reg_date.slice(5, 6) - '0') * 10 + (job.reg_date.slice(6, 7) - '0') - 1;
    var time = job.reg_date.slice(0, 10) + ' ' + job.reg_date.slice(11, 16);
    var title = job.title.slice(0, 50);
    var description = job.description;
    if (description.length > 255)
        description = job.description.slice(0, 247) + '... MORE';

    let html = '<article class="post post-large">' +
        '<div class="post-date">' +
        '<span class="day">' + day + '</span>' +
        '<span class="month">' + monthName[regMonth] + '</span>' +
        '</div>' +
        '<div class="post-content">' +
        '<h2>' +
        '<a href="/hires/' + job.jobId + '">' + title + '</a>' +
        '<span><a href="#" class="label label-success pull-right">NEW</a></span>' +
        '</h2>' +
        '<p>' + description + '</p>' +
        '<div class="post-meta">' +
        '<span class="label label-primary">' + job.categoryName + '</span>' +
        '<span><i class="fa fa-user"></i> By' + '<a href="/users/' + job.userId + '">' + job.userName + '</a> </span>' +
        '<span><i class="fa fa-comments"></i> No Bids</span>' +
        '<span><i class="fa fa-calendar"></i>' + time + '</span>' +
        '<a href="/hires/' + job.jobId + '" class="read-more pull-right">Read more <i class="fa fa-angle-right"></i></a>' +
        '</div>' +
        '</div>' +
        '</article > ';
    $('#job_list').prepend(html);
});
jQuery(document).ready(function () {


});
$(document).ready(main);
function main() {
    //  get_Start();
    $('#search-field').keyup(get_search_results);
    $('#jobCreate').click(function (event) {
        event.preventDefault();
        var send_data = {
            title: $('#job_title').val().trim(),
            description: $('#job_description').val(),
            skills: $('#job_skills').val(),
            user_id: $('#job_user_id').val(),
            state_id: 1,
            category_id: $('#job_category_id').val()
        }
        $.ajax({
            url: '/jobs/create_new_job',
            type: 'get',
            data: { send_data },
            success: function (res) {
                if (res) {
                    window.location = '/jobs';
                    socket.emit('newJob', res);
                }
            },
            error: function (err) {
                console.log("job_save failed");
            }
        });
    });
}
function get_search_results() {
    var limit = $('#jobCount').val();
    var search_query = jQuery('#search-field').val();
    if (search_query != "" && search_query.length >= 2) {
        if (search_query.length == 2) {
            search_query = 0
        }
        $.get('/jobs/' + search_query + '@t' + '/search', function (data, status) {
            if (status == 'success') {
                $('#job_list').html(data);
            }
        })
    }
    else {
        search_query = ""
    }
    var send_data = {
        limit: limit
    }
    $.ajax({
        url: '/jobs/' + search_query + '@t' + '/search',
        type: 'get',
        data: { send_data },
        success: function (res) {
            if (res) {
                $('#job_list').html(res);
                $('#jobCount').val(limit);
            }
        },
        error: function (err) {
            console.log("job_filter failed");
        }
    });
}

// function get_Start()
// {
//     alert("start")
//     $('#dynamic_pager_demo2').bootpag({
//         paginationClass: 'pagination pagination-sm',
//         next: '<i class="fa fa-angle-right"></i>',
//         prev: '<i class="fa fa-angle-left"></i>',
//         total: 10,
//         page: 1,
//         maxVisible: 6 
//     }).on('page', function(event, num){
//         //$("#dynamic_pager_content2").html("Page " + num + " content here"); // or some ajax content loading...
//         get_search_results(num)
//     });
// }

function find_by_category(id) {
    $.get('/jobs/' + id + '@c' + '/search', function (data, status) {
        if (status == 'success') {
            $('a.side_bar_category').attr('style', 'background-color:white;')
            $('a#cate_' + id).attr('style', 'background-color:lightgrey;');
            $('#job_list').html(data);
        }
    })
}

function find_by_state(id) {
    $.get('/jobs/' + id + '@s' + '/search', function (data, status) {
        if (status == 'success') {
            $('a.side_bar_state').attr('style', 'background-color:white;')
            $('a#state_' + id).attr('style', 'background-color:lightgrey;');
            $('#job_list').html(data);
        }
    })
}