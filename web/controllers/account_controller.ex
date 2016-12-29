defmodule HomeBudget.AccountController do
  use HomeBudget.Web, :controller
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__
  plug :find_and_authorize_project
  plug :find_account when action in [:show, :edit, :update, :delete]

  alias HomeBudget.Account

  def index(conn, _params, user, _claims) do
    project = conn.assigns.project |> Repo.preload(:accounts)
    accounts = project.accounts
    render(conn, "index.html", accounts: accounts, current_user: user, project: project)
  end

  def new(conn, _params, user, _claims) do
    project = conn.assigns.project
    changeset = Account.changeset(%Account{})
    render(conn, "new.html", changeset: changeset, current_user: user, project: project)
  end

  def create(conn, %{"account" => account_params}, user, _claims) do
    project = conn.assigns.project
    account_params = Map.put(account_params, "project_id", project.id)
    changeset = Account.changeset(%Account{}, account_params)

    case Repo.insert(changeset) do
      {:ok, _account} ->
        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: project_account_path(conn, :index, project))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, current_user: user, project: project)
    end
  end

  def show(conn, _params, user, _claims) do
    project = conn.assigns.project
    account = conn.assigns.account
    render(conn, "show.html", account: account, current_user: user, project: project)
  end

  def edit(conn, _params, user, _claims) do
    project = conn.assigns.project
    account = conn.assigns.account
    changeset = Account.changeset(account)
    render(conn, "edit.html", account: account, changeset: changeset, current_user: user, project: project)
  end

  def update(conn, %{"account" => account_params}, user, _claims) do
    project = conn.assigns.project
    account = conn.assigns.account
    changeset = Account.changeset(account, account_params)

    case Repo.update(changeset) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: project_account_path(conn, :index, account))
      {:error, changeset} ->
        render(conn, "edit.html", account: account, changeset: changeset, current_user: user, project: project)
    end
  end

  def delete(conn, _params, _user, _claims) do
    project = conn.assigns.project
    account = conn.assigns.account

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(account)

    conn
    |> put_flash(:info, "Account deleted successfully.")
    |> redirect(to: project_account_path(conn, :index, project))
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You have to log in")
    |> redirect(to: "/")
  end

  defp find_and_authorize_project(conn, _) do
    user = conn.private.guardian_default_resource
    case Repo.get_by(HomeBudget.Project, id: conn.params["project_id"], user_id: user.id) do
      nil ->
        conn
        |> put_flash(:error, "You can't access this page")
        |> redirect(to: dashboard_path(conn, :show))
        |> halt
      project ->
        assign(conn, :project, project)
    end
  end

  def find_account(conn, _) do
    project = conn.assigns.project
    case Repo.get_by(Account, id: conn.params["id"], project_id: project.id) do
      nil ->
        conn
        |> put_flash(:error, "You can't access this page")
        |> redirect(to: project_path(conn, :show, project))
        |> halt
      account ->
        assign(conn, :account, account)
    end
  end
end
