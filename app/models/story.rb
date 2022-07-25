class Story < ApplicationRecord
  belongs_to :chief
  belongs_to :writer
  belongs_to :reviewer
  belongs_to :organization
end
