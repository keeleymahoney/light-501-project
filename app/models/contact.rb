# frozen_string_literal: true

class Contact < ApplicationRecord
    belongs_to :member, optional: true
end
