// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

let chatContain = $(".chat-contain");

function payload (body) {
  return { body: body, time: new Date()}
}

function addElement(container, html) {
  container.append(html);
}

if (chatContain) {
  let entrySource   = $("#entry-template").html();
  let entryTemplate = Handlebars.compile(entrySource);

  let userSource   = $("#user-template").html();
  let userTemplate = Handlebars.compile(userSource);

  let chatContainer = $(".chat-container");
  let msgContainer = $("#msg-container");
  let usersContainer = $(".users-container");

  let roomId = chatContainer.data("id");
  let msgInput = $("#msg-input");
  let button = $("#msg-submit");

  socket.connect()

  let channel = socket.channel("rooms:" + roomId);

  button.on("click", function() {
    channel.push("new_entry", payload(msgInput.val()) )
      .receive("error", error => { console.log(error) })
    msgInput.val("");
  });

  channel.on("new_entry", (res) =>{
    let context = {name: res.name, message: res.body, time: res.time }
    addElement(msgContainer, entryTemplate(context));
  });

  channel.on("leave", (res) =>{
    $('.user#'+res.id + ' .online').text("Online: false")
  });

  channel.on("user_joined", (res) =>{
    $('.user#'+ res.id + ' .online').text("Online: true")
  });

  channel.join()
  .receive("ok", resp => {
    channel.push("history")
      .receive("error", error => { console.log(error) })
    channel.push("users")
      .receive("error", error => { console.log(error) })

    channel.on("history", (res) => {
      $.each(res.entries, function(_key, value ) {
        let context = {name: value.user.username, message: value.message, time: value.at }
        addElement(msgContainer, entryTemplate(context));
      });
    });

    channel.on("users", (res) => {
      $.each(res.users, function(_key, value ) {
        console.log(value);
        let context = {id: value.id, name: value.username, online: value.online, avatar: value.avatar }
        addElement(usersContainer, userTemplate(context));
      });
    });
  })
  .receive("error", resp => { console.log("Unable to join", resp) })
}
