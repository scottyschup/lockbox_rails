module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice'
      'usa-alert usa-alert-success'
    when 'alert'
      'usa-alert usa-alert-error'
    end
  end
end
