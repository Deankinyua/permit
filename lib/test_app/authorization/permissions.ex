defmodule TestApp.Authorization.Permissions do
  use Permit.Ecto.Permissions, actions_module: TestApp.Authorization.Actions

  def can(user) do
    permit()
    |> all(TestApp.Books.Book, user_id: user.id)
    |> read(TestApp.Books.Book, public: true)
  end
end
