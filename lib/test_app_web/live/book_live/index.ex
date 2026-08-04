defmodule TestAppWeb.BookLive.Index do
  use TestAppWeb, :live_view

  import TestApp.Authorization

  alias TestApp.Books

  @impl true
  def resource_module, do: TestApp.Books.Book

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Books
        <:actions>
          <.button variant="primary" navigate={~p"/books/new"}>
            <.icon name="hero-plus" /> New Book
          </.button>
        </:actions>
      </.header>

      <.table
        id="books"
        rows={@streams.loaded_resources}
        row_click={fn {_id, book} -> JS.navigate(~p"/books/#{book}") end}
      >
        <:col :let={{_id, book}} label="Name">{book.name}</:col>
        <:col :let={{_id, book}} label="Pages">{book.pages}</:col>
        <:action :let={{_id, book}}>
          <%= if can(@current_scope.user) |> show?(book) do %>
            <div class="sr-only">
              <.link navigate={~p"/books/#{book}"}>Show</.link>
            </div>
          <% end %>
          <%= if can(@current_scope.user) |> edit?(book) do %>
            <.link navigate={~p"/books/#{book}/edit"}>Edit</.link>
          <% end %>
        </:action>
        <:action :let={{id, book}}>
          <%= if can(@current_scope.user) |> edit?(book) do %>
            <.link
              phx-click={JS.push("delete", value: %{id: book.id}) |> hide("##{id}")}
              data-confirm="Are you sure?"
            >
              Delete
            </.link>
          <% end %>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Listing Books")}
  end

  @impl true
  @permit_action :delete
  def handle_event("delete", %{"id" => _id}, socket) do
    book = socket.assigns.loaded_resource

    {:ok, _} = Books.delete_book(socket.assigns.current_scope, book)

    {:noreply, stream_delete(socket, :loaded_resources, book)}
  end

  @impl true
  def handle_info({type, %TestApp.Books.Book{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :books, list_books(socket.assigns.current_scope), reset: true)}
  end

  defp list_books(current_scope) do
    Books.list_books(current_scope)
  end
end
