defmodule Healthlocker.Caseload.RoomController do
  alias Healthlocker.{EPJSUser, Message, Room, User, Slam.ServiceUser}
  use Healthlocker.Web, :controller

  def show(conn, %{"id" => id, "user_id" => user_id}) do
    room = Repo.get((from r in Room, preload: [messages: :user]), id)
    messages = Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    user = Repo.get!(User, user_id)
    service_user = ServiceUser.for(user)
    slam_user = ReadOnlyRepo.one(from e in EPJSUser,
                where: e."Patient_ID" == ^service_user.slam_id)

    conn
    |> assign(:service_user, nil)
    |> assign(:room, room)
    |> assign(:messages, messages)
    |> assign(:slam_user, slam_user)
    |> assign(:user, user)
    |> assign(:current_user_id, conn.assigns.current_user.id)
    |> render("show.html")
  end
end
