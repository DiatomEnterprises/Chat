defmodule ChatDemo.RoomChannel do
  use ChatDemo.Web, :channel
  alias ChannelServices.RoomService

  def join("rooms:" <> room_id, payload, socket) do
    if authorized?(payload) do
      RoomService.join_room(socket.assigns.user, room_id);
      socket = assign(socket, :room_id, room_id)
      send(self, :after_join)
      {:ok, assign(socket, :room_id, room_id)}

    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    broadcast socket, "user_joined", %{id: socket.assigns.user.id }
    {:noreply, socket}
  end


  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("history", _payload, socket) do
    push socket, "history", RoomService.history(socket.assigns.room_id)
    {:noreply, socket}
  end

  def handle_in("users", _payload, socket) do
    push socket, "users", RoomService.users(socket.assigns.room_id)
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (rooms:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end


  def handle_in("new_entry", payload, socket) do
    case RoomService.create_entry(socket.assigns.user, socket.assigns.room_id,  payload) do
      {:ok, entry} ->
        broadcast! socket, "new_entry", %{
          name: socket.assigns.user.username,
          body: entry.message,
          time: entry.inserted_at
        }
        {:reply, :ok, socket}
      {:error, _reason} ->
    end
  end


  # def handle_out(event, payload, socket) do
  #   push socket, event, payload
  #   {:noreply, socket}
  # end

  def terminate({reason, action}, socket) do
    RoomService.channel_action(socket.assigns.user, action)
    user = socket.assigns.user
    broadcast socket, "leave", %{
      id: user.id
    }
    :ok
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
