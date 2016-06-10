class Word < ActiveRecord::Base
  has_many :word_parsers
  has_many :phonetic_notations
  has_many :phonetics, through: :phonetic_notations
  has_many :meanings
  acts_as_paranoid
  validates :name, :length,  presence: true

  def who
    @word = self
    puts @word.name
  end

  def load_explain_from_baidu_hanyu
    require 'net/http'
    @word = self
    path = "/zici/s?wd=" + @word.name
    response = Net::HTTP.get_response("hanyu.baidu.com", path)
    pinyin = response.body.scan(/<span><b>(.*?)<\/b>/)
    pinyin.each do |py|
      the_phonetic = Phonetic.find_by(content: py)
      unless the_phonetic
        the_phonetic = Phonetic.create(content: py, label: "")
      end
      @word.phonetic_notations.create(phonetic_id: the_phonetic.id)
    end
    number = pinyin.size
    explains = response.body.scan(/<dl>(.*?)<\/dl>/)[0..number-1].join(" ")
    @word.meanings.create(content: explains)
  end

end
