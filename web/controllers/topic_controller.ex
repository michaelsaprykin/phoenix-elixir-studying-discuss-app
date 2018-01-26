defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    render conn, "index.html", topics: Repo.all(Topic)
  end

  def new(conn, _params) do
    Topic.changeset(%Topic{}) |> render_new_with_change_set(conn)
  end

  def create(%{assigns: %{user: user}} = conn, %{"topic" => topic}) do
    IO.inspect conn
    user
    |> build_assoc(:topics)
    |> Topic.changeset(topic)
    |> Repo.insert
    |> render_new_success_or_error_response(conn)
  end

  def render_new_success_or_error_response(response, conn) do
    case response do
      {:ok, _topic} ->
        conn
          |> put_flash(:info, "Topic Created")
          |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> render_new_with_change_set(changeset, conn)
    end
  end

  def render_new_with_change_set(changeset, conn) do
    render conn, "new.html", changeset: changeset
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    render conn, "edit.html", topic: topic, changeset: changeset
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    old_topic
    |> Topic.changeset(topic)
    |> Repo.update
    |> render_edit_success_or_error_response(conn, old_topic)
  end

  def render_edit_success_or_error_response(response, conn, topic) do
    case response do
      {:ok, _topic} ->
        conn
          |> put_flash(:info, "Topic Successfully Edited")
          |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:warning, "Error with editing topic")
        |> render("edit.html", changeset: changeset, topic: topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id)
    |> Repo.delete!

    conn
    |> put_flash(:info, "Topic deleted")
    |> redirect(to: topic_path(conn, :index))
  end

end
