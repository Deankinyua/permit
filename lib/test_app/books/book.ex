defmodule TestApp.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "books" do
    field :name, :string
    field :pages, :integer
    field :public, :boolean, default: false

    belongs_to :user, TestApp.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(book, attrs, user_scope) do
    book
    |> cast(attrs, [:name, :pages])
    |> validate_required([:name, :pages])
    |> put_change(:user_id, user_scope.user.id)
  end
end
