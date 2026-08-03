defmodule TestApp.BooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TestApp.Books` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "some name",
        pages: 42
      })

    {:ok, book} = TestApp.Books.create_book(scope, attrs)
    book
  end
end
