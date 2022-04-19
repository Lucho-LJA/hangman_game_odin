path_file = "./google-10000-english-no-swears.txt"
module General_game

    public
    def General_game.title(name = "Player")
        n = 70
        welcome_str = " Welcome #{name} to HANGMAN GAME "
        for i in 0..n do print "\#" end
        print "\n"
        for i in 0..(n-welcome_str.length)/2 do print "\#" end
        print welcome_str
        for i in 0..(n-welcome_str.length)/2 do print "\#" end
        print "\n"
        for i in 0..n do print "\#" end
        print "\n\n"
        for i in 0..n do print "\#" end
        print "\n"
        puts %{These are the Rules:
        - Guess the hidden word letter by letter
        - Guess bofore the draw is complete
        - Write save if you want to save the game
        - If you saved the game, select the option load game
        \n"Luck and Go Ahead!        }
        for i in 0..n do print "\#" end
        print "\n\n"
        puts "Choose a option"
        puts "\t- (1) New Game"
        puts "\t- (2) Load Game"
        puts "\t- (3) Exit"
        return gets.chomp.to_i
    end
    private

    def draw_hangman(num=0)
        array = [" ","_","_","_","_\n",
            " ","|"," "," "," |\n",
            " "," "," "," "," |\n",
            " "," "," "," "," |\n",
            " "," "," "," "," |\n",
            "_","_","_","_","_|\n"
            ]
        case num
            when 0
                array[11] = " "
                array[16] = " "
                array[10] = " "
                array[12] = " "
                array[20] = " "
                array[22] = " "
            when 1
                array[11] = "O"
                array[16] = " "
                array[10] = " "
                array[12] = " "
                array[20] = " "
                array[22] = " "
                
            when 2
                array[11] = "O"
                array[16] = "|"
                array[10] = " "
                array[12] = " "
                array[20] = " "
                array[22] = " "
            when 3
                array[11] = "O"
                array[16] = "|"
                array[10] = "\\"
                array[12] = " "
                array[20] = " "
                array[22] = " "
            when 4
                array[11] = "O"
                array[16] = "|"
                array[10] = "\\"
                array[12] = "/"
                array[20] = " "
                array[22] = " "
            when 5
                array[11] = "O"
                array[16] = "|"
                array[10] = "\\"
                array[12] = "/"
                array[20] = "/"
                array[22] = " "
            else
                array[11] = "O"
                array[16] = "|"
                array[10] = "\\"
                array[12] = "/"
                array[20] = "/"
                array[22] = "\\"
            end
        array
    end

    def new_word(path)
        word = "hangman"
        if File.exist?(path)
            random = Random.new
            random_index = []
            lines = File.readlines(path)
            index_length = lines.length
            value_found = false
            while value_found == false do
                random_num = random.rand(index_length)
                unless random_index.include?(random_num)
                    word = lines[random_num].chomp
                    if word.length < 5 or word.length > 12
                        random_index.push(random_num)
                    else
                        value_found = true
                    end
                end
            end
        else
            puts "No load Dictionary. Choose the word by default"
        end
        return word
    end
end

class Game
    @game_save = false
    @word_game = ""
    @state = 0

    def initialize(name,path)
        @name = name
        @word_game = new_word(path)
        draw_state(@state)
    end

    include General_game

    def draw_state(state)
        puts draw_hangman(state).join('')
    end

end

class Player < Game
    def test
        @word_game
    end
end

option = General_game.title
puts option



