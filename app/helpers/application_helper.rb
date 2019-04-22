module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice'
      'usa-alert usa-alert-success fade'
    when 'alert'
      'usa-alert usa-alert-error fade'
    end
  end
end
