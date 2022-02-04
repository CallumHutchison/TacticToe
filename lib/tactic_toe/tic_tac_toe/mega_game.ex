defmodule TicTacToe.MegaGame do
  defstruct player: "X",
            winner: nil,
            board: %{},
            boards: %{
              {0, 0} => TicTacToe.Game.new(),
              {0, 1} => TicTacToe.Game.new(),
              {0, 2} => TicTacToe.Game.new(),
              {1, 0} => TicTacToe.Game.new(),
              {1, 1} => TicTacToe.Game.new(),
              {1, 2} => TicTacToe.Game.new(),
              {2, 0} => TicTacToe.Game.new(),
              {2, 1} => TicTacToe.Game.new(),
              {2, 2} => TicTacToe.Game.new()
            },
            current_board: :any

  def new do
    %TicTacToe.MegaGame{}
  end

  def make_move(game = %TicTacToe.MegaGame{}, grid, {x, y}) do
    cond do
      game.winner != nil ->
        game

      Map.get(game.board, grid, nil) != nil ->
        {:error, "The grid #{x},#{y} has already been won", game}

      grid == game.current_board or game.current_board == :any ->
        handle_move(game, grid, {x, y})

      true ->
        {:error, "The position #{x},#{y} is outside the bounds of the game grid", game}
    end
  end

  defp handle_move(game = %TicTacToe.MegaGame{}, grid, {x, y}) do
    board = %{game.boards[grid] | player: game.player}

    case TicTacToe.Game.make_move(board, x, y) do
      {:error, message, _board} ->
        {:error, message, game}

      board = %{player: player, winner: winner} ->
        new_board = Map.put(game.board, grid, winner)

        new_game = %TicTacToe.MegaGame{
          player: player,
          boards: Map.put(game.boards, grid, board),
          board: new_board,
          winner: TicTacToe.Game.check_winner(new_board)
        }

        %{new_game | current_board: get_next_grid(new_game, {x, y})}
    end
  end

  defp get_next_grid(game = %TicTacToe.MegaGame{}, pos_played) do
    case game.boards[pos_played].winner do
      nil -> pos_played
      _ -> :any
    end
  end
end
