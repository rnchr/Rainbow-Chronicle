module PlacesHelper
  include ApplicationHelper
  def hours
    hours_of_operation.gsub /\n/, "<br />"
  end
end
