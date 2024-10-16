class Token < ApplicationRecord
  belongs_to :member
  encrypts :access_token
  encrypts :token_exp
end
