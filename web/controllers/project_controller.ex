defmodule HomeBudget.ProjectController do
  use HomeBudget.Web, :controller
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  alias HomeBudget.Project

  def new(conn, _params, user, _claims) do
    changeset = Project.changeset(%Project{})
    render(conn, "new.html", changeset: changeset, current_user: user)
  end

  def create(conn, %{"project" => project_params}, user, _claims) do
    project_params_with_user_id = Map.put(project_params, "user_id", user.id)
    changeset = Project.changeset(%Project{}, project_params_with_user_id)

    case Repo.insert(changeset) do
      {:ok, _project} ->
        conn
        |> put_flash(:info, "Project created successfully.")
        |> redirect(to: dashboard_path(conn, :show))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, current_user: user)
    end
  end

  def show(conn, %{"id" => id}, user, _claims) do
    project = Repo.get!(Project, id)
    render(conn, "show.html", project: project, current_user: user)
  end

  def edit(conn, %{"id" => id}, user, _claims) do
    project = Repo.get!(Project, id)
    changeset = Project.changeset(project)
    render(conn, "edit.html", project: project, changeset: changeset, current_user: user)
  end

  def update(conn, %{"id" => id, "project" => project_params}, user, _claims) do
    project = Repo.get!(Project, id)
    changeset = Project.changeset(project, project_params)

    case Repo.update(changeset) do
      {:ok, _project} ->
        conn
        |> put_flash(:info, "Project updated successfully.")
        |> redirect(to: dashboard_path(conn, :show))
      {:error, changeset} ->
        render(conn, "edit.html", project: project, changeset: changeset, current_user: user)
    end
  end

  def delete(conn, %{"id" => id}, _user, _claims) do
    project = Repo.get!(Project, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(project)

    conn
    |> put_flash(:info, "Project deleted successfully.")
    |> redirect(to: dashboard_path(conn, :show))
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You have to log in")
    |> redirect(to: "/")
  end
end
