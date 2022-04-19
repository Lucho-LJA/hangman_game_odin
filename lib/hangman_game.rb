path_file = "./google-10000-english-no-swears.txt"
module General_game
    def General_game.new_word(path)
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

puts General_game.new_word(path_file)
