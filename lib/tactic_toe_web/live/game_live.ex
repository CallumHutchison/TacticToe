defmodule TacticToeWeb.GameLive do
  use Phoenix.LiveView
  alias TicTacToe.MegaGame, as: Game

  @cells [
    {0, 0},
    {1, 0},
    {2, 0},
    {0, 1},
    {1, 1},
    {2, 1},
    {0, 2},
    {1, 2},
    {2, 2}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :game, Game.new()) |> assign(:cells, @cells)}
  end

  def render(assigns) do
    ~H"""
    <div class="center">
      <h1>
        <%= if @game.winner == nil do %>
          <p><%= @game.player %>'s Turn</p>
        <% else %>
          <p><%= @game.winner %> wins!</p>
        <% end %>
      </h1>
      <div class="mega_game_grid">
        <%= for {x, y} <- @cells do%>
          <.game_grid grid_x={x} grid_y={y} game={assigns.game.boards[{x, y}]} is_active={(assigns.game.current_board == :any or assigns.game.current_board == {x,y}) and assigns.game.winner == nil} cells={assigns.cells}/>
        <% end %>
      </div>
      <div class="control_bar">
        <button phx-click="new_game">New Game</button>
      </div>
    </div>
    """
  end

  def game_grid(assigns) do
    ~H"""
    <%= if @game.winner == nil do %>
      <div class={if assigns.is_active, do: "game_grid_active", else: "game_grid_inactive"}>
        <%= for {x, y} <- @cells do%>
          <button phx-click="move" phx-value-grid-x={assigns.grid_x} phx-value-grid-y={assigns.grid_y} phx-value-x={x} phx-value-y={y}><%= @game.board[{x,y}] %></button>
        <% end %>
    </div>
    <% else %>
      <span class="won_grid"><%= @game.winner %></span>
    <% end %>

    """
  end

  def handle_event("move", %{"grid-x" => grid_x, "grid-y" => grid_y, "x" => x, "y" => y}, socket) do
    grid = {String.to_integer(grid_x), String.to_integer(grid_y)}
    pos = {String.to_integer(x), String.to_integer(y)}

    case Game.make_move(socket.assigns.game, grid, pos) do
      {:error, _, _} -> {:noreply, socket}
      new_game_state -> {:noreply, assign(socket, :game, new_game_state |> IO.inspect())}
    end
  end

  def handle_event("new_game", _, socket) do
    {:noreply, assign(socket, :game, Game.new())}
  end
end
