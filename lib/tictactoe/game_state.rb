# Encoding: utf-8

module Tictactoe
  class GameState
    BLANK = ''

    attr_reader :board, :player_piece, :opponent_piece, :board_size

    def initialize(board, player_piece, opponent_piece)
      validate_piece player_piece
      validate_piece opponent_piece
      validate_pieces_different player_piece, opponent_piece
      @player_piece = player_piece
      @opponent_piece = opponent_piece
      validate_board board
      @board = board
      @board_size = board.length
    end

    def is_over?
      has_someone_won? || is_draw?
    end

    def has_someone_won?
      win_for_piece?(player_piece) || win_for_piece?(opponent_piece)
    end

    def is_draw?
      !has_someone_won? && !@board.flatten.include?(BLANK)
    end

    def have_i_won?(player_piece)
      win_for_piece? player_piece
    end

    def have_i_lost?(player_piece)
      !is_draw? && !win_for_piece?(player_piece)
    end

    def board_empty?
      board.flatten.count('') == board_size**2
    end

    def available_moves
      board.flatten.each_with_index.map do |value, index|
        row = (index / board_size)
        [row, index - row * board_size] if value == BLANK
      end.compact
    end

    def apply_move(choice)
      new_board = board.map { |row| row.map { |space| space.dup } }
      new_board[choice.first][choice.last] = player_piece
      GameState.new(new_board, opponent_piece, player_piece)
    end

    private

      def validate_piece(piece)
        fail ArgumentError, "Piece #{piece} must be a single character." if piece.length != 1
      end

      def validate_pieces_different(first_player, second_player)
        fail ArgumentError, 'You can not have both pieces be the same character.' if first_player.downcase == second_player.downcase
      end

      def validate_board(board)
        board_size = board.length
        if board_size != board.count { |row| row.length == board_size }
          fail ArgumentError, 'Provided board is not square.'
        end
        if board.flatten.reject { |piece| [player_piece, opponent_piece, BLANK].include? piece }.length > 0
          fail ArgumentError, 'Board contains invalid pieces.'
        end
      end

      def winning_row?(piece)
        board.each do |row|
          return true if row.count(piece) == board_size
        end
        false
      end

      def winning_column?(piece)
        board.transpose.each do |row|
          return true if row.count(piece) == board_size
        end
        false
      end

      def winning_diagonal?(piece)
        board.each_with_index do |row, index|
          return false unless row[index] == piece
        end
        true
      end

      def winning_reverse_diagonal?(piece)
        board.each_with_index do |row, index|
          return false unless row[board_size - index - 1] == piece
        end
        true
      end

      def win_for_piece?(piece)
        winning_row?(piece) || winning_column?(piece) || winning_diagonal?(piece) || winning_reverse_diagonal?(piece)
      end
  end
end
