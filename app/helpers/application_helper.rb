module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice'
      'alert alert-success alert-dismissible fade show'
    when 'alert'
      'alert alert-danger alert-dismissible fade show'
    end
  end
end
