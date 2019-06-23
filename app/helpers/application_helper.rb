module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice'
      'alert alert-success fade show'
    when 'alert'
      'alert alert-danger fade show'
    end
  end
end
