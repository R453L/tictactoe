# Encoding: utf-8

require 'app/game_state'

module App
  module Player
    class PerfectPlayer
      def get_new_state(game_state)
        @game_state = game_state
        @player = @game_state.active_turn
        @other_payer = @player == 'x' ? 'o' : 'x'
        @choice = []

        if @game_state.get_blanks.length == 9
          # If its the first move pick a random good starting move
          puts 'start-move'
          @game_state.get_new_state([[0, 2].sample, [0, 2].sample])
        elsif @game_state.get_blanks.length == 1
          # Pick the last available space if there is only one
          puts 'last-move'
          @game_state.get_new_state(@game_state.get_blanks.first)
        else
          # Determine the best possible move via a minimax calculation
          puts 'ai-move'
          # Whoever is playing is trying to maximize their game
          max_choice(@game_state)
          @game_state.get_new_state(@choice)
        end
      end

      private

        def max_choice(state)
          # Check for an end condition
          n = -100_000
          if state.win?(@player)
            return 1
          elsif state.win?(@other_payer)
            return -1
          elsif state.draw?
            return 0
          else
            # Loop through each available space
            state.get_blanks.each do | choice |
              new_state = state.get_new_state(choice)
              next_choice = min_choice(new_state)
              if next_choice > n
                n = next_choice
                @choice = choice
              end
            end
            return n
          end
        end

        def min_choice(state)
          n = 100_000
          if state.win?(@player)
            return 1
          elsif state.win?(@other_payer)
            return -1
          elsif state.draw?
            return 0
          else
            # Loop through each available space
            state.get_blanks.each do | choice |
              new_state = state.get_new_state(choice)
              next_choice = max_choice(new_state)
              if next_choice < n
                n = next_choice
                @choice = choice
              end
            end
            return n
          end
        end
    end
  end
end