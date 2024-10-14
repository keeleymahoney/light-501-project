class Request < ApplicationRecord
  belongs_to :member

  enum :request_type, %i[network_access constitution_access network_addition]
  enum :status, %i[unsettled accepted rejected]
end
