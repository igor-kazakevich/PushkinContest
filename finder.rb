require 'json'

class Finder
  def initialize
    @letters = ["о", "а", "е", "и", "н", "т", "р", "с", "л", "в", "к", "п", "м", 
      "у", "д", "я", "ы", "ь"]

    file = File.read('json_base/hash_title.json')
    @hash_title = JSON.parse(file)

    file = File.read('json_base/hash_line.json')
    @hash_line = JSON.parse(file)

    file = File.read('json_base/hash_search_word.json')
    @hash_search_word = JSON.parse(file)

    puts "FINDER INITIALIE!!!"
  end

  def findLine(question)
    index = ""
    @letters.each do |l|
      index += question.count(l).to_s
    end
    return @hash_line[index]
  end

  def findLineWithError(question)
    @index = []

    @letters.each do |l|
      @index << question.count(l).to_s
    end

    @hash_line.each_key do |key|
      @key = key.split(//)

      @difference = 0

      @index.each_with_index do |item, i|
        break if @difference > 2
        @difference += 1 unless @key[i] == item
      end

      next if @difference > 2

      if @difference <= 2
        return @hash_line[key]
      end
    end

    return nil
  end

  def findWord(question)
    question.gsub!(/[,'—«»;:.!?()]/, "")
    question.gsub!(/[[:blank:]]/, "")
    question.gsub!("%WORD%", "")

    return @hash_search_word[question]
  end

  def findTitle(question)
    index = ""
    @letters.each do |l|
      index += question.count(l).to_s
    end

    return @hash_title[index]
  end

  def find_change_word(question)
    question.gsub!(/[,'—«»;:.!?()]/, "")
    question.gsub(/[[:blank:]]/, " ").split(" ").each do |word|
      index = question.gsub(word, "").gsub(/[[:blank:]]/, "")
      unless @hash_search_word[index].nil?
        return @hash_search_word[index] + "," + word
      end
    end
  end

end