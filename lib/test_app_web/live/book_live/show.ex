defmodule TestAppWeb.BookLive.Show do
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
        Book {@loaded_resource.id}
        <:subtitle>This is a book record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/books"}>
            <.icon name="hero-arrow-left" />
          </.button>

          <%= if can(@current_scope.user) |> edit?(@loaded_resource) do %>
            <.button variant="primary" navigate={~p"/books/#{@loaded_resource}/edit?return_to=show"}>
              <.icon name="hero-pencil-square" /> Edit book
            </.button>
          <% end %>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@loaded_resource.name}</:item>
        <:item title="Pages">{@loaded_resource.pages}</:item>
        <:item title="Public">{@loaded_resource.public}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => _id}, _session, socket) do
    if connected?(socket) do
      Books.subscribe_books(socket.assigns.current_scope)
    end

    {:ok, assign(socket, :page_title, "Show Book")}
  end

  @impl true
  def handle_info(
        {:updated, %TestApp.Books.Book{id: id} = book},
        %{assigns: %{book: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :book, book)}
  end

  def handle_info(
        {:deleted, %TestApp.Books.Book{id: id}},
        %{assigns: %{book: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current book was deleted.")
     |> push_navigate(to: ~p"/books")}
  end

  def handle_info({type, %TestApp.Books.Book{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
