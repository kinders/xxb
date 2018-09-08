class PhoneticNotation < ApplicationRecord
  belongs_to :phonetic
  belongs_to :word
end
