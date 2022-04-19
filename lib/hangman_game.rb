require 'FileUtils'
require 'json'
PATH_FILE = "./google-10000-english-no-swears.txt"
PATH_GAME = "./save_game/saved_game.json"
PATH_FILE_GAME = "./save_game"

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
            while !value_found do
                random_num = random.rand(index_length)
                unless random_index.include?(random_num)
                    word = lines[random_num].chomp
                    word.length < 5 or word.length > 12 ? random_index.push(random_num) : value_found = true
                end
            end
        else
            puts "No load Dictionary. Choose the word by default"
        end
        return word
    end
end

class Game
    @@game_init = false
    @@name = ""
    def initialize(path,game_save=false)
        @path = path
        @game_save = game_save
        @word_display = []
        @@name = input_name unless @@game_init or game_save
        @@game_init = true
        @state = 0
        unless game_save
            @word_game = new_word(@path)
            @word_display = @word_game.split('').map!{|item| item = "___"}
            draw_state(@state)
            welcome_player(@@name, @word_display.join(' '))
        end
    end

    def load_game(path)
        file_load= File.new(path)
        var_game = JSON.load(file_load)
        file_load.close
        @state = var_game["state"]
        @@name = var_game["name"]
        @word_game = var_game["word_game"]
        @word_display = var_game["word_display"]
        draw_state(@state)
        welcome_player(@@name, @word_display.join(' '))
    end

    def save_game
        puts "Saving Game"
        Dir.mkdir(PATH_FILE_GAME) unless Dir.exist?(PATH_FILE_GAME)
        str_class ={path:@path, word_display:@word_display,word_game:@word_game,
            game_init:true,name:@@name, state:@state}
        File.open(PATH_GAME, "w"){|f| f.puts(str_class.to_json)}
        @@game_init = false
        puts "Game Saved"
    end

    include General_game

    def draw_state(state)
        #p @word_game #uncomment to show the word to guess
        puts draw_hangman(state).join('')
    end

    private 
    def save_correct_chart(chart)
        @word_game.split('').each_with_index do |element, index|
            if element.upcase == chart then @word_display[index] = "_#{chart}_" end
        end
        @word_display.any?{|elem| elem == "___"} ? false : true
    end
end

class Player < Game
    def input_letter
        winner = false
        while !winner and @state < 6 do
            print "\nEnter one chart: "
            option = gets.chomp.upcase
            if option.length == 1 and @word_game.upcase.include?(option)
                winner = save_correct_chart(option)
                puts "Great! Chart: #{option} is correct"
                draw_state(@state)
                puts @word_display.join(' ')
            elsif option == "SAVE"
                save_game
                return 2
            elsif option == "EXIT"
                @@game_init = false
                print "Do you want to save the Game? y/n (n): "
                if gets.chomp.upcase == "Y"
                    save_game
                    return 2
                end
                return 1
            else
                @state += 1
                puts "Wrong! Chart: #{option} is incorrect"
                draw_state(@state)
                puts @word_display.join(' ')
            end
        end
        if @state >= 6 
            puts "YOU LOSE! The correct word is: \n\t#{@word_game}"
            return 0
        elsif winner
            puts "Great, YOU WIN!"
            return 0
        end
    end

    def set_init(val)
        @@game_init = val
    end
end

#Main code
General_game.title
general_game = true
while general_game do
    general_menu = true
    while general_menu do
        option = General_game.General_menu
        if option > 0 and option < 4
            general_menu = false
        else
            puts "\nEnter a unvailable option\n"
        end
    end
    parcial_game = true
    while parcial_game do
        if option == 1
            Dir.exist?(PATH_FILE_GAME) ? FileUtils.rm_r(PATH_FILE_GAME) : 
            player = Player.new(PATH_FILE)
            game_turn = player.input_letter
            if game_turn == 0
                print "Do you want play again? y/n (n): "
                gets.chomp.upcase == "Y" ? parcial_game = true : parcial_game = false
            else
                parcial_game = false
            end
        elsif option == 2
            if Dir.exist?(PATH_FILE_GAME) and File.exist?(PATH_GAME)
                player = Player.new(PATH_FILE,true)
                player.load_game(PATH_GAME)
                game_turn = player.input_letter
                if game_turn == 0
                    print "Do you want play again? y/n (n): "
                    if gets.chomp.upcase == "Y"
                        parcial_game = true
                        option = 1
                    else
                        player.set_init(false)
                        parcial_game = false
                    end
                else
                    player.set_init(false)
                    parcial_game = false
                end
            else
                puts "There is not a saved game.\nPlease, choise new game"
                parcial_game = false
            end

        else
            parcial_game = false
            general_game = false
        end
    end
end
puts "Thanks for play"



