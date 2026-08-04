defmodule TestApp.Authorization do
  use Permit.Ecto, permissions_module: TestApp.Authorization.Permissions, repo: TestApp.Repo
end
