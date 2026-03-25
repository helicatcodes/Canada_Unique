class Token < ApplicationRecord
  enum :status, { pending: "pending", accepted: "accepted", expired: "expired" }
end
