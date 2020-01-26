# This will use the money formatting specified by default in rails-i18n, e.g.:
#   Money.new(10_000_00, 'USD').format # => $10,000.00
Money.locale_backend = :i18n
Money.default_currency = Money::Currency.new("USD")
Money.rounding_mode = BigDecimal::ROUND_HALF_UP
