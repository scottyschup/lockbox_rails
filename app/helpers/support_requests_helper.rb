module SupportRequestsHelper
  def expense_category_select_options
    LockboxTransaction::EXPENSE_CATEGORIES.map { |c| [c.capitalize, c] }
  end
end
