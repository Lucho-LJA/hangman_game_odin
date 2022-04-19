path_file = "./google-10000-english-no-swears.txt"
module General_game
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

    private
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
    @game_end = false
    @word_game = ""

    def initialize(name,path)
        @name = name
        @word_game = new_word(path)
    end

    include General_game

end

class Player < Game
    def test
        @word_game
    end
end
player1 = Player.new("Luis",path_file)
puts player1.draw_hangman(0).join('')
puts player1.draw_hangman(1).join('')
puts player1.draw_hangman(2).join('')
puts player1.draw_hangman(3).join('')
puts player1.draw_hangman(4).join('')
puts player1.draw_hangman(5).join('')
puts player1.draw_hangman(6).join('')


