defmodule HomeBudget.AccountControllerTest do
  use HomeBudget.ConnCase

  import HomeBudget.Factory

  alias HomeBudget.Account

  @valid_attrs %{account_type: "some content", name: "some content", parrent_acount_id: 0 }
  @valid_update_attrs %{account_type: "other content", name: "updated content"}
  @invalid_attrs %{name: ""}

  describe "index" do
    test "renders account list", %{conn: conn} do
       user = insert(:user)
       project = insert(:project, user_id: user.id)
       conn = guardian_login(user)
              |> get(project_account_path(conn, :index, project))
       assert html_response(conn, 200) =~ "Listing accounts"
    end

    test "redirects to home page when user is not logged in", %{conn: conn} do
      conn = get conn, project_account_path(conn, :index, "fake_project_id")
      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "redirects to dashboar when user has no permissions" do
      user = insert(:user)
      project = insert(:project)
      conn = guardian_login(user)
      conn = get conn, project_account_path(conn, :index, project.id)
      assert redirected_to(conn) == dashboard_path(conn, :show)
    end
  end

  describe "new" do
    test "renders form for new resources", %{conn: conn} do
      user = insert(:user)
      project = insert(:project, user_id: user.id)
      conn = guardian_login(user)
             |> get(project_account_path(conn, :new, project))
      assert html_response(conn, 200) =~ "New account"
    end

    test "redirects to home page when user is not logged in", %{conn: conn} do
      conn = get conn, project_account_path(conn, :new, "fake_project_id")
      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "redirects to dashboar when user has no permissions" do
      user = insert(:user)
      project = insert(:project)
      conn = guardian_login(user)
      conn = get conn, project_account_path(conn, :new, project)
      assert redirected_to(conn) == dashboard_path(conn, :show)
    end
  end

  describe "create" do
    test "creates account and redirects when data is valid", %{conn: conn} do
      user = insert(:user)
      project = insert(:project, user_id: user.id)
      conn = guardian_login(user)
             |> post(project_account_path(conn, :create, project), account: @valid_attrs)
      assert redirected_to(conn) == project_account_path(conn, :index, project)
      assert Repo.get_by(Account, @valid_attrs).project_id == project.id
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      user = insert(:user)
      project = insert(:project, user_id: user.id)
      conn = guardian_login(user)
             |> post(project_account_path(conn, :create, project), account: @invalid_attrs)
      assert html_response(conn, 200) =~ "New account"
    end

    test "redirects to home page when user is not logged in", %{conn: conn} do
      conn = post conn, project_account_path(conn, :create, "fake_project_id")
      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "redirects to dashboar when user has no permissions" do
      user = insert(:user)
      project = insert(:project)
      conn = guardian_login(user)
      conn = post conn, project_account_path(conn, :create, project)
      assert redirected_to(conn) == dashboard_path(conn, :show)
    end
  end

  describe "show" do
    test "shows selected account when user is logged in", %{conn: conn} do
      user = insert(:user)
      project = insert(:project, user_id: user.id)
      account = insert(:account, project_id: project.id)
      conn = guardian_login(user)
             |> get(project_account_path(conn, :show, project, account))
      assert html_response(conn, 200) =~ "Show account"
    end

    test "redirects to project when logged in user try to access other user account", %{conn: conn} do
      user = insert(:user)
      project = insert(:project, user_id: user.id)
      conn = guardian_login(user)
             |> get(project_account_path(conn, :show, project, 999))

      assert redirected_to(conn) == project_path(conn, :show, project)
    end
    
    test "redirects to home page when user is not logged in", %{conn: conn} do
      conn = get conn, project_account_path(conn, :show, 999, 999)
      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "redirects to dashboar when logged user has no permissions to access selected project" do
      user = insert(:user)
      project = insert(:project)
      conn = guardian_login(user)
      conn = get conn, project_account_path(conn, :show, project, 999)
      assert redirected_to(conn) == dashboard_path(conn, :show)
    end
  end

  describe "edit" do
    test "renders edit page for selected account when user is logged in", %{conn: conn} do
      user = insert(:user)
      project = insert(:project, user_id: user.id)
      account = insert(:account, project_id: project.id)
      conn = guardian_login(user)
             |> get(project_account_path(conn, :edit, project, account))
      assert html_response(conn, 200) =~ "Edit account"
    end

    test "redirects to project when logged in user try to edit account without permission", %{conn: conn} do
      user = insert(:user)
      project = insert(:project, user_id: user.id)
      conn = guardian_login(user)
             |> get(project_account_path(conn, :edit, project, 999))

      assert redirected_to(conn) == project_path(conn, :show, project)
    end

    test "redirects to home page when user is not logged in", %{conn: conn} do
      conn = get conn, project_account_path(conn, :edit, 999, 999)
      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "redirects to dashboar when logged user has no permissions to access selected account" do
      user = insert(:user)
      project = insert(:project)
      conn = guardian_login(user)
      conn = get conn, project_account_path(conn, :edit, project, 999)
      assert redirected_to(conn) == dashboard_path(conn, :show)
    end
  end

  describe "update" do
    test "updates chosen  account and redirects when data is valid and user is logged in", %{conn: conn} do
      user = insert(:user)
      project = insert(:project, user_id: user.id)
      account = insert(:account, project_id: project.id)
      conn = guardian_login(user)
             |> put(project_account_path(conn, :update, project, account), account: @valid_update_attrs)
      assert redirected_to(conn) == project_account_path(conn, :index, account)
      assert Repo.get_by(Account, @valid_update_attrs)
    end

    test "does not update chosen account and renders errors when data is invalid and user is logged in", %{conn: conn} do
      user = insert(:user)
      project = insert(:project, user_id: user.id)
      account = insert(:account, project_id: project.id)
      conn = guardian_login(user)
            |> put(project_account_path(conn, :update, project, account), account: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit account"
    end

    test "redirects to project when logged in user try to update account without permission", %{conn: conn} do
      user = insert(:user)
      project = insert(:project, user_id: user.id)
      conn = guardian_login(user)
             |> put(project_account_path(conn, :update, project, 999))

      assert redirected_to(conn) == project_path(conn, :show, project)
    end

    test "redirects to home page when user is not logged in", %{conn: conn} do
      conn = put conn, project_account_path(conn, :update, 999, 999)
      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "redirects to dashboar when logged user has no permissions to update project" do
      user = insert(:user)
      project = insert(:project)
      conn = guardian_login(user)
      conn = put conn, project_account_path(conn, :update, project, 999)
      assert redirected_to(conn) == dashboard_path(conn, :show)
    end
  end

  describe "delete" do
    test "delete choosen account and redirects when user is logged", %{conn: conn} do
      user = insert(:user)
      project = insert(:project, user_id: user.id)
      account = insert(:account, project_id: project.id)
      conn = guardian_login(user)
             |> delete(project_account_path(conn, :delete, project, account))
      assert redirected_to(conn) == project_account_path(conn, :index, project)
      refute Repo.get(Account, account.id)
    end

    test "redirects to project when logged in user try to delete account without permission", %{conn: conn} do
      user = insert(:user)
      project = insert(:project, user_id: user.id)
      conn = guardian_login(user)
             |> delete(project_account_path(conn, :delete, project, 999))
      assert redirected_to(conn) == project_path(conn, :show, project)
    end

    test "redirects to home page when user is not logged in", %{conn: conn} do
      conn = delete conn, project_account_path(conn, :delete, 999, 999)
      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "redirects to dashboar when logged user has no permissions to access selected projecgt", %{conn: conn} do
      user = insert(:user)
      project = insert(:project)
      conn = guardian_login(user)
            |> delete(project_account_path(conn, :delete, project, 999))
      assert redirected_to(conn) == dashboard_path(conn, :show)
    end
  end
end
