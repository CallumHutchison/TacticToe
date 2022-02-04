defmodule TicTacToe.Player do
  def play do
    clear_screen()
    play(TicTacToe.Game.new())
  end

  def play(game = %TicTacToe.Game{}) do
    print_game(game)
    IO.puts("#{game.player}'s turn")
    {x, y} = get_move()

    clear_screen()

    game =
      case TicTacToe.Game.make_move(game, x, y) do
        {:error, message, game} -> handle_error(message, game)
        game -> game
      end

    if game.winner == nil do
      play(game)
    else
      print_game(game)

      case game.winner do
        :draw -> "It's a draw!"
        winner -> "#{winner} wins!"
      end
      |> IO.puts()
    end
  end

  def clear_screen() do
    IO.puts("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
  end

  def print_game(game = %TicTacToe.Game{}) do
    IO.puts(TicTacToe.Game.board_to_string(game))
  end

  def handle_error(message, game) do
    IO.puts(message)
    game
  end

  def get_move() do
    IO.gets("Please type a position to play in the format: x,y\n")
    |> String.replace("\n", "")
    |> String.replace(" ", "")
    |> String.split(",")
    |> Enum.map(&String.to_integer(&1))
    |> List.to_tuple()
  end
end
