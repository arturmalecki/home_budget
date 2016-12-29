defmodule HomeBudget.ProjectControllerTest do
  use HomeBudget.ConnCase

  import HomeBudget.Factory

  alias HomeBudget.Project

  @valid_attrs %{name: "home budget"}
  @invalid_attrs %{name: ""}

  setup do
    {:ok, %{user: insert(:user)}}
  end

  describe "when user is not logged in" do
    test "returns to home page when try to hit new/2", %{conn: conn} do
      conn = get conn, project_path(conn, :new)
      assert redirected_to(conn) == page_path(conn, :index)
    end
  end

  describe "new/2" do
    test "renders form for new resources", %{user: user} do
      conn = guardian_login(user)
      conn = get conn, project_path(conn, :new)
      assert html_response(conn, 200) =~ "New project"
    end
  end

  describe "create/2" do
    test "creates resource and redirects when data is valid", %{user: user} do
      conn = guardian_login(user)
      conn = post conn, project_path(conn, :create), project: @valid_attrs
      assert redirected_to(conn) == dashboard_path(conn, :show)
      assert Repo.get_by(Project, %{ name: "home budget", user_id: user.id })
    end

    test "does not create resource and renders errors when data is invalid", %{user: user} do
      conn = guardian_login(user)
      conn = post conn, project_path(conn, :create), project: @invalid_attrs
      assert html_response(conn, 200) =~ "New project"
    end
  end

  describe "show/2" do
    test "shows chosen resource", %{user: user} do
      project = insert(:project)
      conn = guardian_login(user)
      conn = get conn, project_path(conn, :show, project)
      assert html_response(conn, 200) =~ "Show project"
    end
  end

  describe "edit/2" do
    test "renders page not found when id is nonexistent", %{user: user} do
      conn = guardian_login(user)
      assert_error_sent 404, fn ->
        get conn, project_path(conn, :show, -1)
      end
    end

    test "renders form for editing chosen resource", %{user: user} do
      project = insert(:project)
      conn = guardian_login(user)
      conn = get conn, project_path(conn, :edit, project)
      assert html_response(conn, 200) =~ "Edit project"
    end
  end

  describe "update/2" do
    test "updates chosen resource and redirects when data is valid", %{user: user} do
      project = insert(:project, user_id: user.id)
      conn = guardian_login(user)
      conn = put conn, project_path(conn, :update, project), project: @valid_attrs
      assert redirected_to(conn) == dashboard_path(conn, :show)
      assert Repo.get_by(Project, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{user: user} do
      project = insert(:project)
      conn = guardian_login(user)
      conn = put conn, project_path(conn, :update, project), project: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit project"
    end
  end

  test "deletes chosen resource", %{user: user} do
    project = Repo.insert! %Project{}
    conn = guardian_login(user)
    conn = delete conn, project_path(conn, :delete, project)
    assert redirected_to(conn) == dashboard_path(conn, :show)
    refute Repo.get(Project, project.id)
  end
end
