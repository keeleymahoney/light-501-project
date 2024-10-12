class Request < ApplicationRecord
  has_one :member

  enum :request_type, %i[network_access constritution_access network_addition]
  enum :status, %i[unsettled accepted rejected]
end
