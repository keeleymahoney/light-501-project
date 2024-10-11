class Request < ApplicationRecord

  enum :type, [:network_access, :constritution_access, :network_addition]

end
