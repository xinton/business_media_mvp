class Story < ApplicationRecord
  belongs_to :chief, :class_name => "User", foreign_key: :chief_id
  belongs_to :writer, :class_name => "User", foreign_key: :writer_id, optional: true
  belongs_to :reviewer, :class_name => "User", foreign_key: :reviewer_id, optional: true
  belongs_to :organization
end
