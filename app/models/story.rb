class Story < ApplicationRecord
  belongs_to :chief, :class_name => "User", foreign_key: :chief_id
  belongs_to :writer, :class_name => "User", foreign_key: :writer_id, optional: true
  belongs_to :reviewer, :class_name => "User", foreign_key: :reviewer_id, optional: true
  belongs_to :organization

  attr_accessor :writer_id, :reviewer_id

  include AASM

  aasm(column: 'status') do
    state :unassigned
    state :draft
    state :for_review
    state :in_review
    state :pending
    state :approved
    state :published
    state :archived

    event :create_without_writer do
      transitions to: :unassigned
    end

    event :create_with_writer do
      transitions to: :draft
    end

    event :assign_writer do
      transitions from: :unassigned, to: :draft
    end

    event :request_review do
      transitions from: :draft, to: :for_review
    end

    event :start_review do
      transitions to: :for_review, to: :in_review
    end

    event :request_changes do
      transitions to: :in_review, to: :pending
    end

    event :changes_done do
      transitions to: :pending, to: :for_review
    end

    event :approve do
      transitions to: :in_review, to: :approved
    end

    event :publish do
      transitions to: :approved, to: :published
    end

    event :archive do
      transitions to: :approved, to: :archived
    end

  end
end
