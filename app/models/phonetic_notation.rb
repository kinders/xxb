class PhoneticNotation < ActiveRecord::Base
  belongs_to :phonetic
  belongs_to :word
end
