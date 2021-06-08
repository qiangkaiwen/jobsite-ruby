const server = require('http').createServer()
server.listen(8001, function (err) {
    if (err) throw err
    console.log('Chat Server is listening on port 8001')
})
const io = require('socket.io')(server);

io.sockets.on('connection', function(socket) {  
    socket.room = -1;
    // console.log('socket connected...', socket.conn.remoteAddress);

    socket.on('on message', function(data) {
        if(data.action == 'request_invite'){
            //console.log('request_invite', data.room_id, '  sockeID:', socket.id)  
            socket.room = data.room_id;
            socket.join(socket.room);
        }
        else if(data.action == 'send_chat'){
            //console.log('socket.room =', socket.room, ':   data.hire_id =', data.hire_id, '  sockeID:', socket.id)  
             socket.join(socket.room)
             io.sockets.in(socket.room).emit('on message', data)
        }
        
    })
    socket.on('alarm_invitation', function(data) {
        socket.broadcast.emit('alarm_invitation', data);
    })
    socket.on('kicked', function(data) {
        socket.broadcast.emit('kicked', data);
    })
    socket.on('newJob', function(data) {
        socket.broadcast.emit('newJob', data);
    })
    socket.on('disconnect', function () {
        // console.log('socket disconnect...', socket.id)
    })
});



  