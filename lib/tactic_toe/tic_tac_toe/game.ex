defmodule TicTacToe.Game do
  defstruct player: "X", winner: nil, board: %{}

  def new do
    %TicTacToe.Game{}
  end

  def make_move(game = %TicTacToe.Game{}, x, y) do
    cond do
      game.winner != nil ->
        game

      Map.has_key?(game.board, {x, y}) ->
        {:error, "The square #{x},#{y} has already been played", game}

      x in 0..2 and y in 0..2 ->
        make_move(game, {x, y})

      true ->
        {:error, "The position #{x},#{y} is outside the bounds of the game grid", game}
    end
  end

  defp make_move(game = %TicTacToe.Game{}, {x, y}) do
    board = Map.put(game.board, {x, y}, game.player)
    %TicTacToe.Game{board: board, player: change_player(game.player), winner: check_winner(board)}
  end

  defp board_to_tuples(board) do
    {
      {Map.get(board, {0, 0}), Map.get(board, {1, 0}), Map.get(board, {2, 0})},
      {Map.get(board, {0, 1}), Map.get(board, {1, 1}), Map.get(board, {2, 1})},
      {Map.get(board, {0, 2}), Map.get(board, {1, 2}), Map.get(board, {2, 2})}
    }
  end

  defp change_player("X"), do: "O"
  defp change_player("O"), do: "X"
  defp change_player(other), do: throw("Invalid player: #{other}")

  def board_to_string(game = %TicTacToe.Game{}) do
    board = game.board
    "
    2 #{Map.get(board, {0, 2}, "-")}  #{Map.get(board, {1, 2}, "-")}  #{Map.get(board, {2, 2}, "-")}\n
    1 #{Map.get(board, {0, 1}, "-")}  #{Map.get(board, {1, 1}, "-")}  #{Map.get(board, {2, 1}, "-")}\n
    0 #{Map.get(board, {0, 0}, "-")}  #{Map.get(board, {1, 0}, "-")}  #{Map.get(board, {2, 0}, "-")}\n
      0  1  2
    "
  end

  def check_winner(board) do
    played_squares = Map.values(board) |> Enum.filter(&(&1 != nil)) |> Enum.count()

    # This could be done much more concisely mathematically, but I wanted a nice example of pattern matching
    case board_to_tuples(board) do
      {
        {x, x, x},
        {_, _, _},
        {_, _, _}
      }
      when not (x == nil) ->
        x

      {
        {_, _, _},
        {x, x, x},
        {_, _, _}
      }
      when not (x == nil) ->
        x

      {
        {_, _, _},
        {_, _, _},
        {x, x, x}
      }
      when not (x == nil) ->
        x

      {
        {x, _, _},
        {x, _, _},
        {x, _, _}
      }
      when not (x == nil) ->
        x

      {
        {_, x, _},
        {_, x, _},
        {_, x, _}
      }
      when not (x == nil) ->
        x

      {
        {_, _, x},
        {_, _, x},
        {_, _, x}
      }
      when not (x == nil) ->
        x

      {
        {_, _, x},
        {_, x, _},
        {x, _, _}
      }
      when not (x == nil) ->
        x

      {
        {x, _, _},
        {_, x, _},
        {_, _, x}
      }
      when not (x == nil) ->
        x

      _ when played_squares >= 9 ->
        :draw

      _ ->
        nil
    end
  end
end
