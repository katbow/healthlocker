defmodule Healthlocker.PageController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Post

  def index(conn, _params) do
    str = "AQAAADyhSQUqcHkOWTRX80nd0Qfa7rO+x63hsOMqs2UzJd60kzxrYZb8C9Klf4SYQjX1BOV1WFXuDd2xXd36niOxuo67K8iyrnGqqeZgkGE6AOMTeGyHkoY7QoGAagl17DsXS07FhlY8iAIdD4lb2eAYMXd6tXsV4+HSjlJ0ufKL7lCU";
    query =
      """
      DECLARE @UserData VARBINARY(MAX), @passphrase varchar(255), @UserDataString VARCHAR(MAX)--, @userName varchar(255);
      SET @passphrase = HASHBYTES('MD5', N'pass');
      SET @UserDataString = '${str}'
      -- SET @UserDataString =
      SELECT @UserData =
              CAST(N'' AS XML).value(
                  'xs:base64Binary(sql:variable("@UserDataString"))'
                , 'VARBINARY(MAX)'
              )
      ;
      SELECT CONVERT(VARCHAR(8000),DecryptByPassPhrase(@passphrase,@UserData,1,CONVERT(varbinary, 15220)));
      SELECT CONVERT(VARCHAR(8000),DecryptByPassPhrase(@passphrase,@UserData));
      """

      query2 = "SELECT top 10 * from mhlTeamMembers"

    SQL.query(ReadOnlyRepo, query, [])
    |> IO.inspect(label: "decoded string")

    featured_story = Post
                     |> Post.find_stories
                     |> Repo.all
    featured_tip = Post
                   |> Post.find_tips
                   |> Repo.all
    story = if Kernel.length(featured_story) < 1 do
      nil
    else
      featured_story |> Enum.random
    end

    tip = if Kernel.length(featured_tip) < 1 do
      nil
    else
      featured_tip |> Enum.random
    end
    render conn, "index.html", story: story, tip: tip
  end

  def show(conn, %{"id" => id}) do
    render conn, String.to_atom(id)
  end
end
