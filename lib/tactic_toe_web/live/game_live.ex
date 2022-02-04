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
      <p><%= headline_string(@game.winner, @game.player) %></p>
      </h1>
      <div class="mega_game_grid">
        <%= for {x, y} <- @cells do%>
          <.game_grid grid_x={x} grid_y={y} game={assigns.game.boards[{x, y}]} is_active={(assigns.game.current_board == :any or assigns.game.current_board == {x,y}) and assigns.game.winner == nil} cells={assigns.cells}/>
        <% end %>
      </div>
      <div class="control_bar">
        <button phx-click="new_game">New Game</button>
        <button phx-click="undo">Undo</button>
      </div>
      <div class = "instructions">
        <h2>How to play</h2>
        <p>TacticToe is like the classic game of Tic-Tac-Toe (or Noughts and Crosses), but you are playing 10 games at the same time.</p>
        <p>Winning one of the 9 small games wins you 1 square on the large game. The first player to get three squares in a line on the large game wins</p>
        <p>The catch is, you can only play in the grid that corresponds to the square your opponent just played in,
        e.g. if your opponent chose the top right square in the bottom left grid, you must now play in the top right grid.
        If the corresponding grid has already been won, then you can play in any grid</p>
        <p>Pick your moves carefully to avoid giving your opponent advantageous options</p>
      </div>
    </div>
    """
  end

  def headline_string(nil, player), do: "#{player}'s turn"
  def headline_string(:draw, _), do: "It's a draw!"
  def headline_string(winner, _), do: "#{winner} wins!"

  def game_grid(assigns) do
    ~H"""
    <%= if @game.winner == nil do %>
      <div class={if assigns.is_active, do: "game_grid game_grid_active", else: "game_grid"}>
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
      new_game_state -> {:noreply, assign(socket, :game, new_game_state)}
    end
  end

  def handle_event("new_game", _, socket) do
    {:noreply, assign(socket, :game, Game.new())}
  end

  def handle_event("undo", _, socket) do
    {:noreply, assign(socket, :game, Game.undo(socket.assigns.game))}
  end
end
