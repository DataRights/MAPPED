module ApplicationHelper
  def flash_class(key)
    case key
    when "notice" then "alert alert-success alert-dismissible"
    when "alert" then "alert alert-danger alert-dismissible"
    when "success" then "alert alert-success alert-dismissible"
    end
  end
end
