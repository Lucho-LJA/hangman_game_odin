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
    end

    def General_game.General_menu
        puts "Choose a option"
        puts "\t- (1) New Game"
        puts "\t- (2) Load Game"
        puts "\t- (3) Exit"
        return gets.chomp.to_i
    end

    private
    def welcome_player(name, word)
        puts "\n Hi #{name}. Guess the next word"
        puts word
    end
    def input_name
        print "\nEnter your name: "
        gets.chomp
    end

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
    def initialize(path)
        @game_save = false
        @word_game = ""
        @word_display = []
        @name = input_name
        @state = 0
        @word_game = new_word(path)
        p @word_game
        @word_display = @word_game.split('').map!{|item| item = "___"}
        draw_state(@state)
        welcome_player(@name, @word_display.join(' '))
    end

    include General_game

    def draw_state(state)
        puts draw_hangman(state).join('')
    end

    private 
    def save_correct_chart(chart)
        @word_game.split('').each_with_index do |element, index|
            if element.upcase == chart then @word_display[index] = "_#{chart}_" end
        end
        if @word_display.any?{|elem| elem == "___"}
            return false 
        else 
            return true
        end
    end


end

class Player < Game
    def input_letter
        winner = false
        while winner == false and @state < 6 do
            print "\nEnter one chart: "
            option = gets.chomp.upcase
            if option.length == 1 and @word_game.upcase.include?(option)
                winner = save_correct_chart(option)
                puts "Great! Chart: #{option} is correct"
                draw_state(@state)
                puts @word_display.join(' ')
            elsif option == "SAVE"
                puts "Game saved"
            elsif option == "EXIT"
                puts "Do you want to save the Game? y/n"
                if gets.chomp.upcase == "Y"
                    puts "Game saved"
                end
            else
                @state += 1
                puts "Wrong! Chart: #{option} is incorrect"
                draw_state(@state)
                puts @word_display.join(' ')
            end
        end
        if @state >= 6 
            puts "YOU LOSE! The correct word is: \n\t#{@word_game}"
        elsif winner
            puts "Great, YOU WIN!"
        end
    end

    def test
        @word_game
    end
end

#Main code
General_game.title

general_menu = true
while general_menu do
    option = General_game.General_menu
    if option > 0 and option < 4
        general_menu = false
    else
        puts "\nEnter a unvailable option\n"
    end
end

if option == 1
    if Dir.exist?('save_game') then FileUtils.rm_rf('save_game') end
    player = Player.new(path_file)

    player.input_letter

end



