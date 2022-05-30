const express = require("express");
const http = require("http");
const socket_io = require("socket.io");

const app = express();
const httpserver = http.createServer(app);
const io = socket_io(httpserver);

app.use(express.static("public"));

let chats = [];

let cntClient = 0;

io.on("connection", function (socket) {

    cntClient++;

    socket.on("addChat", function (data) {
        date = new Date();
        data.date = "(" + date.getFullYear()
            + '/' + ('0' + (date.getMonth() + 1)).slice(-2)
            + '/' + ('0' + date.getDate()).slice(-2)
            + ' ' + ('0' + date.getHours()).slice(-2)
            + ':' + ('0' + date.getMinutes()).slice(-2)
            + ':' + ('0' + date.getSeconds()).slice(-2) + ")";
        data.invalid = false;
        data.chatNum = chats.length;
        data.posit = [0, 0, 0];
        chats.push(data);
        io.emit("recieveChat", data);
        /*
        fetch('https://ipinfo.io?callback')
            .then(res => res.json())
            .then(json => console.log(json.ip))
            */
    });


    socket.on("delServerChat", function (chatNum) {
        chats[chatNum].invalid= true;
        io.emit("delChat", chatNum);
    });


    socket.on("disconnect", function(){
        cntClient--;
        io.emit("updateCntClient", cntClient);
    });


    socket.on("vote", function (data) {
        chats[data.chatNum].posit[data.newPosit]++;
        chats[data.chatNum].posit[data.oldPosit]--;
        chats[data.chatNum].posit[0] = 0;
        io.emit("updateVote", [
            data.chatNum,
            chats[data.chatNum].posit[1],
            chats[data.chatNum].posit[2]
        ]);
    });


    io.to(socket.id).emit("getInit", chats);

    io.emit("updateCntClient", cntClient);
});

httpserver.listen(3000, function () {
    console.log("server start");
});

